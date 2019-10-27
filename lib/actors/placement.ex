defmodule WMS.Placement do
  @moduledoc """
  `WMS.Placement` is a process that handles cart delivery placement from acquiring to cells.
  """
  require KVS
  require ERP
  require BPE
  require Record
  Record.defrecord(:placement, [:path, :item])

  def auth(_), do: true

  def clear(proc) do
    feed = '/wms/in/' ++ :nitro.compact(BPE.process(proc, :name))
    things = :kvs.all(feed)
    :lists.map(fn x -> :kvs.append(ERP."Item"(x, status: :incart), feed) end, things)
    IO.inspect(things)
  end

  def findPlacement(order) do
    feed = '/wms/in/' ++ :nitro.compact(order)
    things = :kvs.all(feed)

    case :lists.partition(fn ERP."Item"(status: x) -> x == :incart end, things) do
      {[], _} -> {[], feed, []}
      {[h], _} -> {h, feed, :last}
      {[h | _], _} -> {h, feed, []}
    end
  end

  def allocateCell(_item) do
    '/wms/cells/1/2/3'
  end

  def def() do
    BPE.process(
      name: "Default Name",
      flows: [
        BPE.sequenceFlow(name: :First, source: :Created, target: :Main),
        BPE.sequenceFlow(name: :Second, source: :Main, target: :Final)
      ],
      tasks: [
        BPE.beginEvent(name: :Created, module: WMS.Placement),
        BPE.userTask(name: :Main, module: WMS.Placement),
        BPE.endEvent(name: :Final, module: WMS.Placement)
      ],
      beginEvent: :Created,
      endEvent: :Final,
      events: [BPE.messageEvent(name: :AsyncEvent),
               BPE.boundaryEvent(name: :*, timeout: BPE.timeout(spec: {0, {10, 0, 10}}))]
    )
  end

  def action({:request, :Created, _}, proc) do
    IO.inspect("CREATED")
    clear(proc)
    {:reply, proc}
  end

  def action({:request, :Main, _}, proc) do
    case :bpe.doc({:order}, proc) do
      {:order, id} ->
            IO.inspect id
        case findPlacement(id) do
          {[], _, _} ->
            {:reply, :Final, BPE.process(proc, docs: [{:close}])}

          {item, feed, _} ->
            path = allocateCell(item)
            place = placement(path: path, item: item)
            item = ERP."Item"(item, status: :placed)
            :kvs.append(item, feed)
            :kvs.append(item, path)
            {:reply, :Main, BPE.process(proc, docs: [place,{:order,id}])}
        end

      [] ->
        {:reply, :Main, proc}
    end
  end

  def action({:request, :Final, _}, proc) do
    IO.inspect("FINAL")
    {:stop, BPE.process(proc, docs: [{:close}])}
  end

  def action(_, proc), do: {:reply, proc}
end

defmodule WMS.Allocation do
  @moduledoc """
  `WMS.Allocation` is a process that handles cart delivery from cells to allocator.
  """
  require KVS
  require ERP
  require BPE
  require Record
  Record.defrecord(:allocation, [:path, :item])

  def clear(proc) do
    feed = '/wms/out/' ++ :nitro.compact(BPE.process(proc, :name))
    things = :kvs.all(feed)
    :lists.map(fn x -> :kvs.append(ERP."Item"(x, status: :placed), feed) end, things)
    IO.inspect(things)
  end

  def findPlacement(order) do
    feed = '/wms/out/' ++ :nitro.compact(order)
    things = :kvs.all(feed)

    case :lists.partition(fn ERP."Item"(status: x) -> x == :placed end, things) do
      {[], _} -> {[], feed, allocateCell([])}
      {[h], _} -> {h, feed, allocateCell(h)}
      {[h | _], _} -> {h, feed, allocateCell(h)}
    end
  end

  def allocateCell([]), do: []

  def allocateCell(item) do
    key = '/wms/cells/1/2/3'

    case :kvs.get(key, ERP."Item"(item, :id)) do
      {:ok, i} -> key
      {:error, _} -> []
    end
  end

  def def() do
    BPE.process(
      name: "Default Name",
      flows: [
        BPE.sequenceFlow(source: :Created, target: :Main),
        BPE.sequenceFlow(source: :Main, target: :Final)
      ],
      tasks: [
        BPE.beginEvent(name: :Created, module: WMS.Allocation),
        BPE.userTask(name: :Main, module: WMS.Allocation),
        BPE.endEvent(name: :Final, module: WMS.Allocation)
      ],
      beginEvent: :Created,
      endEvent: :Final,
      events: [BPE.messageEvent(name: :AsyncEvent), BPE.boundaryEvent(name: :*, timeout: {0, {0, 0, 10}})]
    )
  end

  def action({:request, :Created}, proc) do
    IO.inspect("CREATED")
    clear(proc)
    {:reply, BPE.process(proc, docs: [{:open}])}
  end

  def action({:request, :Main}, proc) do
    case :bpe.doc({:order}, proc) do
      {:order, id} ->
        case findPlacement(id) do
          {[], _, _} ->
            {:reply, :Final, BPE.process(proc, docs: [{:close}])}

          {item, feed, []} ->
            {:reply, :Main, BPE.process(proc, docs: [{:empty_cell}])}

          {item, feed, path} ->
            alloc = allocation(path: path, item: item)
            item = ERP."Item"(item, status: :acquired, placement: path)
            :kvs.delete(path, ERP."Item"(item, :id))
            :kvs.append(item, feed)
            {:reply, :Main, BPE.process(proc, docs: [alloc])}
        end
    end
  end

  def action({:request, :Final}, proc) do
    IO.inspect("FINAL")
    {:stop, BPE.process(proc, docs: [{:close}])}
  end

  def action(_, proc), do: {:reply, proc}
end

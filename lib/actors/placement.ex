defmodule WMS.Placement do
  @moduledoc """
  `WMS.Placement` is a process that handles cart delivery to/from cells.
  """
  require ERP
  require BPE
  require Record
  Record.defrecord(:placement, [:path,:item])

  def clear(proc) do
     feed = '/wms/in/' ++ :nitro.compact(BPE.process(proc,:name))
     things = :kvs.all feed
     :lists.map fn x -> :kvs.append ERP."Item"(x, status: :incart), feed end, things
     IO.inspect things
  end

  def findPlacement(order) do
     feed = '/wms/in/' ++ :nitro.compact(order)
     things = :kvs.all feed
     case :lists.partition fn ERP."Item"(status: x) -> x == :incart end, things do
       {[],_} -> {[],feed,[]}
       {[h],_} -> {h,feed,:last}
       {[h|_],_} -> {h,feed,[]}
     end
  end

  def allocateCell(_item) do
     '/wms/cells/1/2/3'
  end

  def def() do
    BPE.process(
      name: "Default Name",
      flows: [
        BPE.sequenceFlow(source: :Created, target: :Main),
        BPE.sequenceFlow(source: :Main,    target: :Final),
      ],
      tasks: [
        BPE.beginEvent(name: :Created, module: WMS.Placement),
        BPE.userTask(name:   :Main,    module: WMS.Placement),
        BPE.endEvent(name:   :Final,   module: WMS.Placement)
      ],
      beginEvent: :Created,
      endEvent: :Final,
      events: [BPE.messageEvent(name: :AsyncEvent),
               BPE.boundaryEvent(name: :"*", timeout: {0,{0,0,10}})]
    )
  end

  def action({:request, :Created}, proc) do
    IO.inspect "CREATED"
    clear(proc)
    {:reply, BPE.process(proc, docs: [{:open}])}
  end

  def action({:request, :Main}, proc) do
    case :bpe.doc({:order},proc) do
      {:order, id} ->
         case findPlacement id do
               {[],_,_} -> {:reply, :Final, BPE.process(proc, docs: [{:close}])}
          {item,feed,_} ->
              :kvs.append ERP."Item"(item, status: :placed), feed
              place = placement(path: allocateCell(item), item: item)
              {:reply, :Main, BPE.process(proc, docs: [place])}
         end
      [] -> {:reply, :Main, proc}
    end
  end

  def action({:request, :Final}, proc) do
    IO.inspect "FINAL"
    {:stop, BPE.process(proc, docs: [{:close}])}
  end

  def action(_, proc), do: {:reply, proc}
end

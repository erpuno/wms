defmodule WMS.Placement do
  @moduledoc """
  `WMS.Placement` is a process that handles cart delivery to/from cells.
  """
  require ERP
  require BPE
  require Record
  Record.defrecord(:placement, [:path,:item])

  def def() do
    BPE.process(
      name: :n2o.user(),
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
      events: [BPE.messageEvent(name: :AsyncEvent)]
    )
  end

  def action({:request, :Created}, proc) do
    {:reply, proc}
  end

  def action({:request, :Main}, proc) do
    {:reply, :Main, BPE.process(proc, docs: [placement(path: '/wms/cells/1/2/3', item: 1)])}
  end

  def action({:request, :Final}, proc) do
    {:reply, proc}
  end
  def action(_, proc), do: {:reply, proc}
end

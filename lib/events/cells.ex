defmodule WMS.Cells do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  require BPE
  require ERP
  require Logger

  def event(:init) do
  end

  def event(_), do: []
end

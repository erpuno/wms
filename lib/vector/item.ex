defmodule WMS.Rows.Item do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require Record
  require ERP
  require Logger

  def doc(),
    do:
      "This is the order item representation. " <>
        "Used to draw the items in the order cart"

  def id(), do: ERP."Item"(volume: {0, 1}, price: {0,1})

  def new(name, ERP."Item"(id: n, price: p, volume: v, good: thing)) do
    {s, m} = :dec.mul(p, v)
    {p1,p2} = p
     {:ok, good} = :kvs.get('/wms/goods', thing)

    panel(
      id: FORM.atom([:tr, NITRO.to_list(thing)]),
      class: :td,
      body: [
        panel(
          class: :column10,
          body: NITRO.compact(n)
        ),
        panel(
          class: :column80,
          body: ERP."Good"(good, :name)
        ),
        panel(
          class: :column10,
          body: :erlang.float_to_list(m * :math.pow(10, -s), [{:decimals, 2}])
        )
      ]
    )
  end
end

defmodule WMS.Rows.Order do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require Record
  require ERP
  require Logger

  def doc(),
    do:
      "This is the warehouse order representation. " <>
        "Used to draw the in/out order"

  def id(), do: ERP."Order"(id: 2001, no: '20190916-2001', date: :os.timestamp(), type: :none, status: :filled)

  def new(name, ERP."Order"(id: i, no: no, date: d, type: t, status: stat)) do
    panel(
      id: FORM.atom([:tr, NITRO.to_list(name)]),
      class: :td,
      body: [
        panel(
          class: :column10,
          body: NITRO.compact(i)
        ),
        panel(
          class: :column66,
          body:
           link(
              body: NITRO.compact(no),
              postback: {:items, i}
            )
        ),
        panel(
          class: :column10,
          body: "0"
        ),
        panel(
          class: :column10,
          body: NITRO.compact(stat)
        )
      ]
    )
  end
end

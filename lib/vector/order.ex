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

  def id(), do: ERP."Order"(id: "xxx")

  def new(name, ERP."Order"(id: i, no: no, date: d, type: t)) do
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
              postback: {:order, i}
            )
        ),
        panel(
          class: :column10,
          body: NITRO.compact(d)
        )
      ]
    )
  end
end

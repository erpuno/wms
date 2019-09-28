defmodule WMS.Forms.Geo do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require Logger
  require Record

  def doc(), do: "Error Form."
  def id(), do: {:geo, 0, 0}

  def new(name, {:geo, x,y}) do
    panel(class: form, body: [
      input(id: :x, validation: 'Validation.nums(e, 1, 2)'),
      input(id: :y, validation: 'Validation.nums(e, 1, 2)'),
      link(class: [:button, :sgreen], body: "Got", id: 'button', source: [:x, :y], postback: {:ok})
    ])
  end
end

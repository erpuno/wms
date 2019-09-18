defmodule BPE.Forms.Create do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  use KVS
  require Logger

  def doc(), do: "Dialog for creation of BPE processes."
  def id(), do: {:pi, []}

  def new(name, {:pi, _}) do
    document(
      name: FORM.atom([:pi, name]),
      sections: [sec(name: "New process: ")],
      buttons: [
        but(
          id: FORM.atom([:pi, :decline]),
          title: "Discard",
          class: :cancel,
          postback: {:discard, []}
        ),
        but(
          id: FORM.atom([:pi, :proceed]),
          title: "Create",
          class: [:button, :sgreen],
          sources: [:process_type],
          postback: {:spawn, []}
        )
      ],
      fields: [
        field(
          name: :process_type,
          id: :process_type,
          type: :select,
          title: "Type",
          tooltips: [],
          options: [
            opt(name: WMS.Placement, title: "Walking"),
            opt(name: WMS.Placement, title: "Mobile Cart"),
            opt(
              name: WMS.Placement,
              checked: true,
              title: "Copter"
            )
          ]
        )
      ]
    )
  end
end

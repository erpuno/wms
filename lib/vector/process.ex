defmodule BPE.Rows.Process do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  use BPE
  require ERP
  require Logger
  require Record

  def doc(),
    do:
      "This is the actor table row representation in FORM CSS. Used to draw active processes" <>
        " in <a href=\"bpe.htm\">BPE process table</a> but displayed as class=form."

  def id(), do: process()

  def new(name, proc) do
    pid = process(proc, :id)

    panel(
      id: FORM.atom([:tr, pid]),
      class: :td,
      body: [
        panel(
          class: :column6,
          body:
            link(
              href: "act.htm?p=" <> NITRO.to_binary(pid),
              body: NITRO.to_binary(pid)
            )
        ),
        panel(
          class: :column6,
          body:
            case process(proc, :name) do
              [] -> []
              ERP."Employee"(person: ERP."Person"(cn: cn)) -> cn
              x -> NITRO.compact(x)
            end
        ),
        panel(
          class: :column6,
          body: NITRO.to_list(task(BPE.step(proc,process(proc, :task)), :module))
        ),
        panel(
          class: :column20,
          body:
            case BPE.head(pid) do
              [] -> []
              xx -> NITRO.jse(NITRO.compact(hist(xx, :task)))
            end
        ),
        panel(
          class: :column20,
          body:
            :string.join(
              :lists.map(
                fn x -> NITRO.to_list([:erlang.element(1, x)]) end,
                task(BPE.step(proc, process(proc, :task)), :prompt)
              ),
              ', '
            )
        ),
        panel(
          class: :column10,
          body:
            case process(proc, :task) do
              :Final ->
                []

              _ ->
                [
                  link(
                    postback: {:complete, process(proc, :id), process(proc, :name)},
                    class: [:button, :sgreen],
                    body: "Go",
                    source: [],
                    validate: []
                  )
                ]
            end
        )
      ]
    )
  end
end

defmodule WMS.Cells do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  require BPE
  require ERP
  require Logger

  def investmentsHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column33, body: "Investment"),
        panel(class: :column10, body: "Paid"),
        panel(class: :column2, body: "Name")
      ]
    )
  end

  def incomeHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column66, body: "Monthly Invoice"),
        panel(class: :column10, body: "Amount"),
        panel(class: :column10, body: "From")
      ]
    )
  end

  def outcomeHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column66, body: "Subaccount"),
        panel(class: :column10, body: "Amount"),
        panel(class: :column10, body: "From")
      ]
    )
  end

  def pushInvestments(code) do
      []
  end

  def pushIncome(code) do
      []
  end

  def pushOutcome(code) do
      []
  end

  def event(:init) do
    NITRO.clear(:investmentsHead)
    NITRO.clear(:investmentsRow)
    NITRO.clear(:incomeHead)
    NITRO.clear(:incomeRow)
    NITRO.clear(:outcomeHead)
    NITRO.clear(:outcomeRow)
    NITRO.insert_top(:investmentsHead, WMS.Cells.investmentsHeader())
    NITRO.insert_top(:outcomeHead, WMS.Cells.outcomeHeader())
    NITRO.insert_top(:incomeHead, WMS.Cells.incomeHeader())
    NITRO.clear(:frms)
    NITRO.clear(:ctrl)

    mod = BPE.Forms.Create
    NITRO.insert_bottom(:frms, FORM.new(mod.new(mod, mod.id()), mod.id()))

    NITRO.insert_bottom(
      :ctrl,
      link(
        id: :create_investment,
        body: "New Investment",
        postback: :create_investment,
        class: [:button, :sgreen]
      )
    )

    NITRO.insert_bottom(
      :ctrl,
      link(
        id: :create_income,
        body: "New Income",
        postback: :create_income,
        class: [:button, :sgreen]
      )
    )

    NITRO.insert_bottom(
      :ctrl,
      link(
        id: :create_outcome,
        body: "New Outcome",
        postback: :create_outcome,
        class: [:button, :sgreen]
      )
    )

    NITRO.hide(:frms)

    code = :p |> NITRO.qc() |> NITRO.to_list() |> pushInvestments |> pushIncome |> pushOutcome

    case KVS.get(:writer, '/plm/' ++ code ++ '/income') do
      {:error, _} ->
        WMS.box(WMS.Forms.Error, {:error, 1, "No product found.", []})

      _ ->
        NITRO.update(:n, code)
        NITRO.update(:num, code)
    end
  end

  def event(:create_investment), do: [NITRO.hide(:ctrl), NITRO.show(:frms)]
  def event(:create_income), do: [NITRO.hide(:ctrl), NITRO.show(:frms)]
  def event(:create_outcome), do: [NITRO.hide(:ctrl), NITRO.show(:frms)]
  def event({:discard, []}), do: [NITRO.hide(:frms), NITRO.show(:ctrl)]

  def event(_), do: []
end

defmodule WMS.Index do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require BPE
  require KVS
  require ERP
  require Logger

  def ordersHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column10, body: "Id"),
        panel(class: :column66, body: "Name"),
        panel(class: :column10, body: "Price"),
        panel(class: :column10, body: "Status")
      ]
    )
  end

  def itemsHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column10, body: "Id"),
        panel(class: :column80, body: "Name"),
        panel(class: :column10, body: "Total")
      ]
    )
  end

  def pushOrders(_) do
     for i <- :kvs.feed('/wms/orders/in') do
       NITRO.insert_bottom(
         :ordersRow,
         WMS.Rows.Order.new(FORM.atom([:row, :order, ERP."Order"(i, :id)]), i)
       )
     end
  end

  def pushItems(order) do
    things = :kvs.all '/wms/in/' ++ NITRO.compact(order)
    for i <- things do
      NITRO.insert_bottom(
        :itemsRow,
        WMS.Rows.Item.new(FORM.atom([:row, :item, ERP."Item"(i, :id)]), i)
      )
    end

  end

  def event(:init) do
    NITRO.clear(:frms)
    NITRO.clear(:ctrl)
    NITRO.clear(:ordersHead)
    NITRO.clear(:itemsHead)
    NITRO.clear(:ordersRow)
    NITRO.clear(:itemsRow)
    NITRO.hide(:items)
    NITRO.hide(:orders)

    case N2O.user() do
      [] ->
        NITRO.hide(:head)

        WMS.box(
          WMS.Forms.Error,
          {:error, 1, "Not authenticated", "User must be authenticated in order to view account and transactions"}
        )

      ERP."Employee"(person: ERP."Person"(cn: name)) ->
         send self(), {:direct, {:orders, name} }
    end
  end

  def event({:orders, cn}) do
    NITRO.show(:orders)
    NITRO.clear(:ordersHead)
    NITRO.insert_top(:ordersHead, WMS.Index.ordersHeader())
    NITRO.hide(:frms)
    cn |> pushOrders
  end

  def event({:items, id}) do
    NITRO.show(:items)
    NITRO.clear(:itemsHead)
    NITRO.insert_top(:itemsHead, WMS.Index.itemsHeader())
    {:ok, order} = :kvs.get '/wms/orders/in', id
    NITRO.update(:num, h3(id: :num, body: NITRO.compact(ERP."Order"(order, :no))))
    NITRO.update(:mod, p(id: :mod, body: ["This order is not yet in process. You can ",
                     link(class: [:button,:sgreen], body: "SEND", postback: {:process, id}), " it."]))
    NITRO.clear(:itemsRow)
    NITRO.hide(:frms)
    id |> pushItems
  end
  def event({:process, id}) do
    {:ok, x} = :bpe.start(BPE.process(WMS.Placement.def(),name: id),[{:created}])
    :bpe.complete x
  end
  def event({:off, _}), do: NITRO.redirect("ldap.htm")
  def event(_), do: []
end

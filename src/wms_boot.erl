-module(wms_boot).
-include("wms.hrl").
-compile(export_all).

boot() ->
  Goods =
  [
    #'Good'{ id=1, name = "Homotopy Type Theory. Volumes I,II.", base_qty = 2, class = book },
    #'Good'{ id=2, name = "Keycaps HHKB Red", base_qty = 54, class = components },
    #'Good'{ id=3, name = "Sony VAIO Z 2010", class = computer },
    #'Good'{ id=4, name = "MacBook Air 2013", serial = "1234", class = computer },
    #'Good'{ id=5, name = "MacBook Air 2018", serial = "0000", class = computer }
  ],

  OrdersIn =
  [
    #'Order'{id=1,goods = [#'Item'{good=1},#'Item'{good=2}]},
    #'Order'{id=2,goods = [#'Item'{good=2},#'Item'{good=3}]}
  ],

  OrdersOut =
  [
    #'Order'{id=1,type=out,goods = [#'Item'{good=1},#'Item'{good=2}]},
    #'Order'{id=2,type=out,goods = [#'Item'{good=2},#'Item'{good=3}]}
  ],

  Cells = [],

  Structure =
  [
    {"/wms/goods", Goods},
    {"/wms/orders/in", OrdersIn},
    {"/wms/cells", Cells},
    {"/wms/orders/out", OrdersOut}
  ],

  lists:foreach(fun({Feed, Data}) ->
        case kvs:get(writer, Feed) of
             {ok,_} -> skip;
          {error,_} -> lists:map(fun(X) ->
                       kvs:append(X,Feed) end, Data) end
                  end, Structure),

  ok.

-module(wms_boot).
-include_lib("erp/include/warehouse.hrl").
-compile(export_all).
boot() ->
  Items1 = [#'Item'{id=1,good=1},#'Item'{id=2,good=2}],
  Items2 = [#'Item'{id=3,good=2},#'Item'{id=4,good=3}],
  Items3 = [#'Item'{id=5,good=1},#'Item'{id=6,good=2}],
  Items4 = [#'Item'{id=7,good=2},#'Item'{id=8,good=3}],
  Cells  = [],
  Goods = [ #'Good'{ id=1, name = "Homotopy Type Theory. Vol. I,II", base_qty = 2, class = book },
            #'Good'{ id=2, name = "Keycaps HHKB Red", base_qty = 54, class = components },
            #'Good'{ id=3, name = "Sony VAIO Z 2010", class = computer },
            #'Good'{ id=4, name = "MacBook Air 2013", serial = "1234", class = computer },
            #'Good'{ id=5, name = "MacBook Air 2018", serial = "0000", class = computer } ],
  OrdersIn  = [ #'Order'{id=1001, no = "20190916-1001"},
                #'Order'{id=1002, no = "20190916-1002"},
                #'Order'{id=1003, no = "20190916-1003"},
                #'Order'{id=1004, no = "20190916-1004"} ],
  OrdersOut = [ #'Order'{id=2001, no = "20190916-2001", type=out},
                #'Order'{id=2002, no = "20190916-2001", type=out},
                #'Order'{id=2003, no = "20190916-2001", type=out},
                #'Order'{id=2004, no = "20190916-2002", type=out}],
  Database = [ {"/wms/goods",       Goods},
               {"/wms/orders/in",   OrdersIn},
               {"/wms/orders/out",  OrdersOut},
               {"/wms/cells",       Cells},
               {"/wms/in/1001",     Items1},
               {"/wms/in/1002",     Items2},
               {"/wms/in/1003",     Items3},
               {"/wms/in/1004",     Items4},
               {"/wms/out/2001",    Items1},
               {"/wms/out/2002",    Items2},
               {"/wms/out/2003",    Items3},
               {"/wms/out/2004",    Items4}  ],
  lists:foreach(fun({Feed, Data}) ->
        case kvs:get(writer, Feed) of
             {ok,_} -> skip;
          {error,_} -> lists:map(fun(X) ->
                       kvs:append(X,Feed) end, Data) end
                  end, Database).

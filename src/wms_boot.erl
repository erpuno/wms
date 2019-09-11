-module(wms_boot).
-include("wms.hrl").
-compile(export_all).

boot() ->
  Goods =
  [
    #'Good'{ name = "Homotopy Type Theory. Volumes I,II.", base_qty = 2, class = book },
    #'Good'{ name = "Keycaps HHKB Red", base_qty = 54, class = components },
    #'Good'{ name = "Sony VAIO Z 2010", class = computer },
    #'Good'{ name = "MacBook Air 2013", serial = "1234", class = computer },
    #'Good'{ name = "MacBook Air 2018", serial = "0000", class = computer }
  ],

  Structure =
  [
    {"/wms/goods", Goods}
  ],

  lists:foreach(fun({Feed, Data}) ->
        case kvs:get(writer, Feed) of
             {ok,_} -> skip;
          {error,_} -> lists:map(fun(X) ->
                       kvs:append(X,Feed) end, Data) end
                  end, Structure),

  ok.

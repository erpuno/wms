-ifndef(WMS_HRL).
-define(WMS_HRL, true).

-type unitType() :: unit | weight | capacity.
-type productType() :: unit | weight | weight_unit | unit_weight.
-type cellType() :: shelf | cell | container | dock | warehouse.
-type dim() :: {integer(),integer(),integer()}.
-type barcode() :: ean13 | code128 | [].

-record('Report', {id,
                   date,
                   cell_in,
                   cell_out,
                   detail}).

-record('Detail', {id,
                   good,
                   volume,
                   price,
                   placement}).

-record('Order',  {id,
                   type :: in | out,
                   no,
                   date,
                   client :: term(),
                   goods :: list(#'Detail'{})}).

% WMS SPEC

-record('Category', {id,
                     name,
                     path}).

-record('Unit', {id,
                 name,
                 type :: unitType(),
                 rate,
                 netto,
                 brutto,
                 dim :: dim()}).

-record('Good', {id,
                 name,
                 type :: productType(),
                 base_measure_qty,
                 base_measure_weight,
                 storage_period,
                 lifetime,
                 barcode,
                 serial,
                 unit :: #'Unit'{} }).

-record('Cell', {id,
                 name,
                 type :: cellType(),
                 barcode,
                 zone,
                 parameters,
                 client,
                 categories,
                 max_weight,
                 max_capacity,
                 dim :: dim(),
                 level,
                 priority,
                 class}).

-endif.

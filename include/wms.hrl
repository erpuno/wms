-ifndef(WMS_HRL).
-define(WMS_HRL, true).

-type unitType() :: unit | weight | capacity.
-type productType() :: unit | weight | weight_unit | unit_weight.
-type cellType() :: cell | container | dock | warehouse.
-type dim() :: {integer(),integer(),integer()}.
-type barcode() :: ean13 | code128.

% BPE documents

-record('WMS_Report', {id,
                       date,
                       closed,
                       process_id,
                       task_id,
                       wms_unit_in,
                       wms_unit_out,
                       cell_in,
                       cell_out,
                       qty,
                       weight}).

-record('WMS_Detail', {id,
                       good,
                       process_type,
                       measure_qty,
                       measure_weight,
                       shelf_life,
                       series,
                       qty,
                       weight}).

-record('WMS_Order', {id,
                      type :: in | out,
                      number,
                      date,
                      shipment,
                      client :: term(),
                      goods :: list(#'WMS_Detail'{})
                     }).


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
                 parameters, % only_boxes
                 client,
                 categories,
                 max_weight,
                 max_capacity,
                 dim :: dim(),
                 level,
                 priority,
                 class}).

%%

-record(pbl, {id, product, client, doc_erp, qty, weight}).
-record(tsd_suite, {id, tsd_tasks, process_id, user}).
-record(tsd_task, {id, action, tsd_suite_id, wms_unit, measure_units_qty, qty, measure_units_weight, weight, cell_in, cell_out, user}).
-record(tsd_response, {id, tsd_task_id, type_unit, unit_barcode, measure_unit_qty, measure_unit_weight, cell_in_barcode, cell_out_barcode, qty, weight, shelf_life, production_date, series}).
-record(wms_unit, {id, barcode, client}).

% ACC

-record(client, {id, name, type::supplier|buyer, internal}).
-record(timesheet, {id, user, start_time, finish_time}).
-record(billing, {id, user, tsd_task_id, start, finish}).

-endif.

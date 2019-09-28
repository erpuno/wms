use Mix.Config

config :bpe,
  procmodules: [:bpe, :bpe_account, WMS.Index, WMS.Placement, WMS.Allocation],
  logger_level: :debug,
  logger: [{:handler, :synrc, :logger_std_h,
            %{level: :debug,
              id: :synrc,
              max_size: 2000,
              module: :logger_std_h,
              config: %{type: :file, file: 'wms.log'},
              formatter: {:logger_formatter,
                          %{template: [:time,' ',:pid,' ',:module,' ',:msg,'\n'],
                            single_line: true,}}}}]

config :n2o,
  pickler: :n2o_secret,
  mq: :n2o_syn,
  port: 8048,
  ttl: 60 * 3,
  nitro_prolongate: true,
  mqtt_services: [:erp, :wms],
  ws_services: [:chat],
  upload: "./priv/static",
  protocols: [:n2o_heart, :n2o_nitro, :n2o_ftp],
  routes: WMS.Routes

config :erp,
  boot: [:erp_boot, :acc_boot, :wms_boot]

config :kvs,
  dba: :kvs_rocks,
  dba_st: :kvs_st,
  schema: [:kvs, :kvs_stream, :bpe_metainfo]

config :form,
  registry: [
    LDAP.Forms.Credentials,
    LDAP.Forms.Access,
    BPE.Forms.Create,
    BPE.Rows.Trace,
    BPE.Rows.Process,
    WMS.Forms.Geo,
    WMS.Forms.Error,
    WMS.Rows.Order,
    WMS.Rows.Item
  ]

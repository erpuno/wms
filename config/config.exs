use Mix.Config

config :n2o,
  pickler: :n2o_secret,
  mq: :n2o_syn,
  port: 8048,
  ttl: 60*3,
  nitro_prolongate: true,
  mqtt_services: [:erp, :wms],
  ws_services: [:chat],
  upload: "./priv/static",
  protocols: [:n2o_heart, :n2o_nitro, :n2o_ftp],
  routes: WMS.Routes

config :erp,
  boot: [:erp_boot, :plm_boot, :acc_boot, :pay_boot, :fin_boot, :wms_boot]

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
    WMS.Forms.Error,
    WMS.Rows.Payment,
    WMS.Rows.Investment,
    WMS.Rows.Product
  ]

defmodule WMS.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :wms,
      version: "0.9.6",
      elixir: "~> 1.7",
      description: "WMS Warehouse Management System",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      files: ~w(lib src mix.exs rebar.config LICENSE),
      licenses: ["ISC"],
      maintainers: ["Namdak Tonpa"],
      name: :wms,
      links: %{"GitHub" => "https://github.com/erpuno/wms"}
    ]
  end

  def application() do
    [mod: {WMS.Application, []}, applications: [:syn, :form, :nitro, :ranch, :cowboy, :rocksdb, :kvs, :erp, :bpe, :n2o]]
  end

  def deps() do
    [
      {:n2o, "~> 6.10.2"},
      {:nitro, "~> 4.10.6", override: true},
      {:cowboy, "~> 2.5.0"},
      {:rocksdb, "~> 1.3.2"},
      {:syn, "~> 1.6.3"},
      {:kvs, "~> 6.10.0", override: true},
      {:erp, "~> 0.9.4"},
      {:bpe, "~> 4.10.12"},
      {:form, "~> 4.10.4"},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end

defmodule WMS.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :wms,
      version: "0.9.5",
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
    [ mod: {WMS.Application, []},
      applications: [:syn, :form, :nitro, :ranch, :cowboy, :rocksdb, :kvs, :erp, :bpe, :n2o]
    ]
  end

  def deps() do
    [
      {:n2o, "~> 6.8.1"},
      {:nitro, "~> 4.7.7"},
      {:cowboy, "~> 2.5.0"},
      {:rocksdb, "~> 1.3.2"},
      {:syn, "~> 1.6.3"},
      {:erp, "~> 0.9.4"},
      {:bpe, "~> 4.9.4"},
      {:form, "~> 4.7.0"},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end

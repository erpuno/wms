defmodule WMS.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :wms,
      version: "0.6.0",
      elixir: "~> 1.7",
      description: "WMS Warehouse Management System",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      files: ~w(doc mix.exs LICENSE),
      licenses: ["ISC"],
      maintainers: ["Namdak Tonpa"],
      name: :wms,
      links: %{"GitHub" => "https://github.com/enterprizing/wms"}
    ]
  end

  def application() do
    [mod: {:wms, []}]
  end

  def deps() do
    [
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end

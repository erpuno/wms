defmodule WMS do
  use N2O, with: [:nitro]
  use FORM

  def extract(name, path, form), do: FORM.atom([name, path, form]) |> NITRO.q() |> NITRO.to_list()
  def extract(name, path), do: FORM.atom([name, path]) |> NITRO.q() |> NITRO.to_list()
  def extract(name), do: name |> NITRO.q() |> NITRO.to_list()

  def box(mod, r) do
    NITRO.clear(:stand)

    rec =
      case r do
        [] -> mod.id
        x -> x
      end

    NITRO.insert_bottom(:stand, FORM.new(mod.new(mod, rec), rec))
  end

  def auth(cn, branch) do
    IO.inspect cn
    IO.inspect branch
    case :kvs.get(:PersonCN, cn) do
      {:ok, {:PersonCN, _, acc}} ->
        case :kvs.get(branch, acc) do
          {:ok, p} -> {:ok, p}
          x -> x
        end

      x ->
        x
    end
  end
end

defmodule WMS.Application do
  use Application

  def home(name) do
    {:ok, [[dir]]} = :init.get_argument(:home)
    :filename.join(dir, name)
  end

  def env(app) do
    [
      {:port, :application.get_env(:n2o, :port, 8048)},
      {:certfile, home('depot/synrc/cert/ecc/server.pem')},
      {:keyfile, home('depot/synrc/cert/ecc/server.key')},
      {:cacertfile, home('depot/synrc/cert/ecc/caroot.pem')}
    ]
  end

  def start(_, _) do
    :bpe_otp.respawn()
    :cowboy.start_tls(:http, env(:wms), %{env: %{dispatch: :n2o_cowboy2.points()}})
    :n2o.start_ws()
    Supervisor.start_link([], strategy: :one_for_one, name: WMS.Supervisor)
  end
end

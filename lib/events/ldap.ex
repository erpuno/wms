defmodule LDAP.Index do
  use N2O, with: [:n2o, :nitro]
  use FORM
  require ERP
  require Logger

  def event(:init) do
    case N2O.user() do
      [] -> event({:off, []})
      _ -> event(:on)
    end
  end

  def event({:auth, form}) do
    cn = WMS.extract(:cn, :otp, form)
    branch = WMS.extract(:branch, :otp, form)

    case WMS.auth(cn, branch) do
      {:ok, p} ->
        N2O.user(p)
        NITRO.redirect("wms.htm")

      {:error, _} ->
        WMS.box(
          WMS.Forms.Error,
          {:error, 1, "The user cannot be found in this branch.", []}
        )
    end
  end

  def event({:close, _}), do: NITRO.redirect("kvs.htm")
  def event({:revoke, x}), do: [N2O.user([]), event({:off, x})]
  def event(:on), do: WMS.box(LDAP.Forms.Access, [])
  def event({:off, _}), do: WMS.box(LDAP.Forms.Credentials, [])
  def event(_), do: []
end

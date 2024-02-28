defmodule OdysBackend.Repo do
  use Ecto.Repo,
    otp_app: :odys_backend,
    adapter: Ecto.Adapters.Postgres
end

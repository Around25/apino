defmodule Apino.Repo do
  use Ecto.Repo,
    otp_app: :apino,
    adapter: Ecto.Adapters.Postgres
end

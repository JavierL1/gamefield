defmodule Gamefield.Repo do
  use Ecto.Repo,
    otp_app: :gamefield,
    adapter: Ecto.Adapters.Postgres
end

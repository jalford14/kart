defmodule Kart.Repo do
  use Ecto.Repo,
    otp_app: :kart,
    adapter: Ecto.Adapters.Postgres
end

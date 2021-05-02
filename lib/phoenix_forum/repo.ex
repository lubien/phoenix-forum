defmodule PhoenixForum.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_forum,
    adapter: Ecto.Adapters.Postgres
end

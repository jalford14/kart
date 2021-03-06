# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kart,
  ecto_repos: [Kart.Repo]

# Configures the endpoint
config :kart, KartWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "i2LQ4pQlRBw5IDmzZIJbAYhncUens35DPd6ZMSCMrZ/PqCBxHtEfpGoCruVrXa/w",
  render_errors: [view: KartWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kart.PubSub,
  live_view: [signing_salt: "/V4tXoO9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :oauth2, debug: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

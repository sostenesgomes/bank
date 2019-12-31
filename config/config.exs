# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank,
  ecto_repos: [Bank.Repo]

# Configures the endpoint
config :bank, BankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "F7yihjntKRjn/bGNcwWGw9ItdXCvdwfToK4u77/QGbZZaoPYJBer1OzesWATzMGD",
  render_errors: [view: BankWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bank.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bank, Bank.Auth.Guardian,
  issuer: "bank",
  secret_key: "mYNLPLd5F6x/1t8UVf73VSftNNC9pQcXh/+riEC5K5tmYH/50bmEUwDUjhow2NLF"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

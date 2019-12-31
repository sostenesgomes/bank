use Mix.Config

# Configure your database
config :bank, Bank.Repo,
  username: System.get_env("PG_PASSWORD") || "postgres",
  password: System.get_env("PG_PASSWORD") || "postgres",
  database: "bank_test",
  hostname: System.get_env("PG_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bank, BankWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :iris, Iris.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :iris, Iris.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "iris_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :iris, Mqtt.Messenger,
  client_id: "iris-server",
  host: "localhost",
  port: 1883

config :iris, Iris.Mailer,
  adapter: Bamboo.LocalAdapter

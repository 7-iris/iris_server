# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :iris,
  ecto_repos: [Iris.Repo]

# Configures the endpoint
config :iris, IrisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kdl17scWn5kPZxPtO8n6NE0eMwC7c2PIcFLhG+LQTp2jUDCNI5N6tHwXC3dCFLRq",
  render_errors: [view: IrisWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Iris.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

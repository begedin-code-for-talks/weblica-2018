# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :weblica,
  ecto_repos: [Weblica.Repo]

# Configures the endpoint
config :weblica, WeblicaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "X5nD18COzNtkVxUNoyZmPB+7L2n43t8ryYw7xNd4zmS1nsBetu9IPvzlRTjcHmjP",
  render_errors: [view: WeblicaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Weblica.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

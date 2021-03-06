# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bebemayotte,
  ecto_repos: [Bebemayotte.Repo]

  config :phoenix,
    template_engines: [leex: Phoenix.LiveView.Engine]
# Configures the endpoint
config :bebemayotte, BebemayotteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "w2OJ0kInCK+f7766/jEbrPb7EQLpAc4BsZ2Voqm7lNBbm+MwCd7OgqN6Vu4HXu+i",
  render_errors: [view: BebemayotteWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bebemayotte.PubSub,
  live_view: [signing_salt: "ndzum7Su"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bebemayotte, Bebemayotte.Mailer,
  adapter: Bamboo.SMTPAdapter,
  # server: "ssl0.ovh.net",
  hostname: "bbmay.fr",
  server: "smtp.office365.com",
  # tls_verify: :verify_peer,
  port: 587,
  # username: "noreply@bbmay.fr",
  username: "bbmaymayotte@outlook.fr",
  password: "Mgbi@261!",
  # tls: :always,
  retries: 1
  # adapter: Bamboo.SMTPAdapter,
  # server: "mail.gmx.com",
  # port: 25,
  # username: "bbmay@gmx.com",
  # password: "Mgbi@261!",
  # tls: :if_available,
  # auth: :always,
  # retries: 1

  config :geolix, :databases, [
    %{
      id: :city,
      adapter: Geolix.Adapter.MMDB2,
      source: "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=KXEimZ4YGmzwmkQg&suffix=tar.gz"
    },
    %{
      id: :country,
      adapter: Geolix.Adapter.MMDB2,
      source: "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=KXEimZ4YGmzwmkQg&suffix=tar.gz"
    }
  ]


# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

config :stripity_stripe,
  api_key: "sk_test_51Kw097FOzddwIWWthyJcaaBvDjnUueA3F6YgvT8eg1815vBTbdSiqSEbOEZ8KsKPqMAgDWOrIrnfnaCIWZKBV5Kq00BTEXChAb",
  signing_secret: "whsec_9c777862c5fffc07d385dc2637a0325a125166c959fafd4675d9c67902cdf7c6"
# config :stripity_stripe, api_key: "sk_test_51J2tO5K8dyJGmpJkF5ozXE96FgIXsDxUukD9aGsFIKosXjdp6UIZIVXkpF4OGHmtpYSXs8MAXePXfVtwT5awGDfZ00fxg8ay8l"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

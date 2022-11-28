import Config
# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :live_bin, LiveBinWeb.Endpoint, server: true
end

if config_env() == :prod do
  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling:
        mix phx.gen.secret
      or, if you don't have phoenix generators installed:
        openssl rand -base64 48
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :live_bin, LiveBinWeb.Endpoint,
    url: [host: host, port: 443],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  bin_inactivity_timeout =
    case System.fetch_env("LIVE_BIN_INACTIVITY_TIMEOUT") do
      {:ok, inactivity_timeout} ->
        String.to_integer(inactivity_timeout)

      :error ->
        :infinity
    end

  config :live_bin, :bin_inactivity_timeout, bin_inactivity_timeout

  config :live_bin, :bin_max_requests, System.get_env("LIVE_BIN_MAX_REQUESTS")

  if System.get_env("LIVE_BIN_USE_BIN_SUBDOMAINS") do
    config :live_bin, :use_bin_subdomains, true
  end
end

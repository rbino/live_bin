import Config

host = System.get_env("MFPB_HOST", "localhost")
port = System.get_env("MFPB_PORT", "4000")
scheme = System.get_env("MFPB_SCHEME", "http")

check_origin =
  if host != "localhost" do
    ["//*.#{host}"]
  else
    true
  end

secret_key_base =
  case System.fetch_env("SECRET_KEY_BASE") do
    {:ok, secret} ->
      secret

    :error ->
      raise """
      You must provide the SECRET_KEY BASE environment variable.
      You can generate  a valid secret with:
        mix phx.gen.secret
      or, if you don't have phoenix generators installed:
        openssl rand -base64 48
      """
  end

config :mfpb, MFPBWeb.Endpoint,
  server: true,
  secret_key_base: secret_key_base,
  http: [:inet6, port: String.to_integer(port)],
  url: [scheme: scheme, host: host, port: port],
  check_origin: check_origin

bin_inactivity_timeout =
  case System.fetch_env("MFPB_BIN_INACTIVITY_TIMEOUT") do
    {:ok, inactivity_timeout} ->
      String.to_integer(inactivity_timeout)

    :error ->
      :infinity
  end

config :mfpb, :bin_inactivity_timeout, bin_inactivity_timeout

config :mfpb, :bin_max_requests, System.get_env("MFPB_BIN_MAX_REQUESTS")

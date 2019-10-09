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

config :mfpb, MFPBWeb.Endpoint,
  server: true,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
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

import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_bin, LiveBinWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "O0LsTZ2PbuXPv/iR8cCKx22g++ziCH9vl88BxOxi8RWfnpgry9G55O8EcYUu7eb5",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

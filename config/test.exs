import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :echo_request, EchoRequestWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "JOaDkNafP+sUe2kJeSzg6DfcEDuWp66NlM9iZdtoyV4x7GdwDd0GmpMjaTWHBDR8",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

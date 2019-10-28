use Mix.Config

config :intercom,
  http_adapter: Intercom.MockHTTPoison,
  access_token: "abcde"

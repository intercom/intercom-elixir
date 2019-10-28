use Mix.Config

config :intercom, :http_adapter, HTTPoison

import_config "#{Mix.env()}.exs"

defmodule Intercom.Client do
  use HTTPoison.Base

  defp process_request_headers(headers) do
    Enum.into(headers, [Accept: "application/json"])
  end

  def process_url(url) do
    "https://api.intercom.io" <> url
  end

  def auth(app_id, api_key) do
    [basic_auth: {app_id, api_key}]
  end
end

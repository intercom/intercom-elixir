defmodule Intercom.API.Rest do
  def url(path) do
    "https://api.intercom.io/" <> path
  end

  def authorized_headers do
    case Intercom.API.Authentication.get_access_token() do
      {:ok, access_token} ->
        {:ok,
         [
           Authorization: "Bearer #{access_token}",
           Accept: "application/json",
           "Content-Type": "application/json"
         ]}

      {:error, error} ->
        {:error, error}
    end
  end
end

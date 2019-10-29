defmodule Intercom.API do
  @type success :: {:ok, map()}
  @type error :: {:error, atom() | %HTTPoison.Error{}, String.t() | nil}
  @type response :: success | error

  @spec call_endpoint(:get | :post, String.t(), map() | nil) :: response()
  def call_endpoint(method, path, body \\ nil) do
    with url <- Intercom.API.Rest.url(path),
         {:ok, authorized_headers} <- Intercom.API.Rest.authorized_headers(),
         {:ok, response} <-
           Intercom.API.Request.make_request(method, url, authorized_headers, body) do
      {:ok, response}
    else
      {:error, error} ->
        {:error, error, error_message(error)}
    end
  end

  defp error_message(error) do
    access_token_help =
      "Configure your access token in config.exs. See https://developers.intercom.com/building-apps/docs/authentication-types#section-how-to-get-your-access-token for information about how to get your access token."

    case error do
      :no_access_token ->
        "No access token found. #{access_token_help}"

      :invalid_access_token ->
        "Invalid access token. #{access_token_help}"

      _ ->
        nil
    end
  end
end

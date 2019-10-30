defmodule Intercom.API do
  @moduledoc """
  Provides direct access to the Intercom API if other modules in
  this package don't provide the functionality you need.

  See https://developers.intercom.com/intercom-api-reference/reference
  """

  @type success :: {:ok, map()}
  @type error :: {:error, atom() | %HTTPoison.Error{}, String.t() | nil}
  @type response :: success | error

  @doc """
  Call an Intercom API endpoint.

  Arguments:
  - `method`: The HTTP request method.
  - `path`: The request path, e.g `"users/1234"`.
  - `body`: The body of the request. Optional.

  Returns `{:ok, data}` or `{:error, error, message}`.
  """
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

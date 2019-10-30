defmodule Intercom.API.Request do
  @moduledoc false

  @http_adapter Application.get_env(:intercom, :http_adapter)

  def make_request(:get, url, headers, nil) do
    @http_adapter.get(url, headers, []) |> parse_response()
  end

  def make_request(:post, url, headers, body) do
    @http_adapter.post(url, Jason.encode!(body), headers, []) |> parse_response()
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body} = response}) do
    case Jason.decode(body) do
      {:ok, json} ->
        {:ok, json}

      {:error, _} ->
        {:error, response}
    end
  end

  defp parse_response({:ok, response}) do
    {:error, response}
  end

  defp parse_response({:error, error}), do: {:error, error}
end

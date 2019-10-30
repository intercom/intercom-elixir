defmodule Intercom.APIEndpoint do
  import Mox

  defmacro assert_rest_endpoint(method, path, body \\ nil, do: yield) do
    quote do
      http_adapter = Application.get_env(:intercom, :http_adapter)
      api_endpoint = "https://api.intercom.io/"
      json_body = Jason.encode!(unquote(body))
      success_response = %HTTPoison.Response{status_code: 200, body: json_body}
      url = "#{api_endpoint}#{unquote(path)}"

      case unquote(method) do
        :get ->
          expect(http_adapter, :get, fn ^url, _headers, _options ->
            {:ok, success_response}
          end)

        :post ->
          expect(http_adapter, :post, fn ^url, ^json_body, _headers, _options ->
            {:ok, success_response}
          end)
      end

      assert {:ok, _} = unquote(yield)
    end
  end
end

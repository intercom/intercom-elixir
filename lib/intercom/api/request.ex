defmodule Intercom.API.Request do
  @http_adapter Application.get_env(:intercom, :http_adapter)

  def make_request(:get, url, headers, nil) do
    @http_adapter.get(url, headers, [])
  end

  def make_request(:post, url, headers, body) do
    @http_adapter.post(url, body, headers, [])
  end
end

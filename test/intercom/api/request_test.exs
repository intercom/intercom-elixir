defmodule Intercom.API.RequestTest do
  use ExUnit.Case
  import Mox
  doctest Intercom

  @module Intercom.API.Request
  @http_adapter Application.get_env(:intercom, :http_adapter)

  setup :verify_on_exit!

  describe "make_request/4" do
    test "with :get method and nil body makes call to HTTPoison get" do
      url = "https://example.com/users"
      headers = ["Authorization": "Bearer abcde"]
      expect(@http_adapter, :get, fn ^url, ^headers, [] -> {:ok, nil} end)
      @module.make_request(:get, url, headers, nil)
    end

    test "with :post method makes call to HTTPoison post" do
      url = "https://example.com/users"
      headers = ["Authorization": "Bearer abcde"]
      body = "{\"user_id\": 25}"
      expect(@http_adapter, :post, fn ^url, ^body, ^headers, [] -> {:ok, nil} end)
      @module.make_request(:post, url, headers, body)
    end
  end
end

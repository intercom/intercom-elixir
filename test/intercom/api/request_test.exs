defmodule Intercom.API.RequestTest do
  use ExUnit.Case
  import Mox

  @module Intercom.API.Request
  @http_adapter Application.get_env(:intercom, :http_adapter)
  @url "https://example.com/users"
  @headers ["Authorization": "Bearer abcde"]
  @json_body "{\"user_id\": 25}"

  setup :verify_on_exit!

  describe "make_request/4" do
    test "with :get method and nil body makes call to HTTPoison get" do
      expect(@http_adapter, :get, fn @url, @headers, [] -> {:ok, nil} end)
      @module.make_request(:get, @url, @headers, nil)
    end

    test "with :post method makes call to HTTPoison post" do
      expect(@http_adapter, :post, fn @url, @json_body, @headers, [] -> {:ok, nil} end)
      @module.make_request(:post, @url, @headers, @json_body)
    end

    test "returns map of parsed JSON body when JSON returned with 200 response" do
      expect(@http_adapter, :get, fn @url, @headers, [] -> {:ok, %HTTPoison.Response{status_code: 200, body: @json_body}} end)
      assert @module.make_request(:get, @url, @headers, nil) == {:ok, %{"user_id" => 25}}
    end

    test "returns error with response data if status_code is not 200" do
      expect(@http_adapter, :get, fn @url, @headers, [] -> {:ok, %HTTPoison.Response{status_code: 418, body: @json_body}} end)
      assert @module.make_request(:get, @url, @headers, nil) == {:error, %HTTPoison.Response{status_code: 418, body: @json_body}}
    end

    test "returns error with response data if body isn't valid JSON" do
      expect(@http_adapter, :get, fn @url, @headers, [] -> {:ok, %HTTPoison.Response{status_code: 200, body: "potato"}} end)
      assert @module.make_request(:get, @url, @headers, nil) == {:error, %HTTPoison.Response{status_code: 200, body: "potato"}}
    end

    test "passes errors through from HTTPoison" do
      expect(@http_adapter, :get, fn @url, @headers, [] -> {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}} end)
      assert @module.make_request(:get, @url, @headers, nil) == {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}}
    end
  end
end

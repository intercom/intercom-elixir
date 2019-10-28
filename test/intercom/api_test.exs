defmodule Intercom.APITest do
  use ExUnit.Case, async: false
  import Mox
  doctest Intercom

  @module Intercom.API
  @http_adapter Application.get_env(:intercom, :http_adapter)
  @valid_access_token "abcde"
  @json_body "{\"user_id\": 25}"
  @success_response %HTTPoison.Response{status_code: 200, body: @json_body}
  @parsed_body %{"user_id" => 25}

  setup :verify_on_exit!

  setup do
    on_exit(fn ->
      Application.delete_env(:intercom, :access_token)
    end)
  end

  describe "call_endpoint/3" do
    test "makes authorized get requests" do
      Application.put_env(:intercom, :access_token, @valid_access_token)
      expect(@http_adapter, :get, fn _url, _headers, _options -> {:ok, @success_response} end)

      assert @module.call_endpoint(:get, "users") == {:ok, @parsed_body}
    end

    test "makes authorized post requests" do
      Application.put_env(:intercom, :access_token, @valid_access_token)
      expect(@http_adapter, :post, fn _url, _body, _headers, _options -> {:ok, @success_response} end)

      assert @module.call_endpoint(:post, "users", "{\"user_id\": 25}") == {:ok, @parsed_body}
    end

    test "returns error messages for known errors" do
      expected_error_message =
        "No access token found. Configure your access token in config.exs. See https://developers.intercom.com/building-apps/docs/authentication-types#section-how-to-get-your-access-token for information about how to get your access token."

      assert @module.call_endpoint(:get, "users") ==
               {:error, :no_access_token, expected_error_message}
    end

    test "returns raw unknown error messages" do
      expected_error = %HTTPoison.Error{id: nil, reason: :econnrefused}
      Application.put_env(:intercom, :access_token, @valid_access_token)
      expect(@http_adapter, :get, fn _url, _headers, _options -> {:error, expected_error} end)

      assert @module.call_endpoint(:get, "users") == {:error, expected_error, nil}
    end
  end
end

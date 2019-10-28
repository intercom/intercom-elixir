defmodule Intercom.UsersTest do
  use ExUnit.Case
  import Mox

  @module Intercom.Users
  @http_adapter Application.get_env(:intercom, :http_adapter)
  @api_endpoint "https://api.intercom.io/"
  @json_body "{\"user_id\":\"a25\"}"
  @success_response %HTTPoison.Response{status_code: 200, body: @json_body}
  @body %{"user_id" => "a25"}

  describe "get/1" do
    test "calls correct rest endpoint" do
      expect(@http_adapter, :get, fn "#{@api_endpoint}users/a25", _headers, _options ->
        {:ok, @success_response}
      end)

      assert @module.get("a25") == {:ok, @body}
    end
  end

  describe "get_by/1" do
    test "calls correct rest endpoint when user_id passed" do
      expect(@http_adapter, :get, fn "#{@api_endpoint}users?user_id=a25", _headers, _options ->
        {:ok, @success_response}
      end)

      assert @module.get_by(user_id: "a25") == {:ok, @body}
    end

    test "calls correct rest endpoint when email passed" do
      expect(@http_adapter, :get, fn "#{@api_endpoint}users?email=bob@bob.com",
                                     _headers,
                                     _options ->
        {:ok, @success_response}
      end)

      assert @module.get_by(email: "bob@bob.com") == {:ok, @body}
    end
  end

  describe "upsert/1" do
    test "calls correct rest endpoint" do
      expect(@http_adapter, :post, fn "#{@api_endpoint}users", @json_body, _headers, _options ->
        {:ok, @success_response}
      end)

      assert @module.upsert(@body) == {:ok, @body}
    end
  end
end

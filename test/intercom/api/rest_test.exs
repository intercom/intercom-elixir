defmodule Intercom.API.RestTest do
  use ExUnit.Case, async: false

  @module Intercom.API.Rest
  @valid_access_token "abcde"

  setup do
    access_token = Application.get_env(:intercom, :access_token)

    on_exit(fn ->
      Application.put_env(:intercom, :access_token, access_token)
    end)
  end

  describe "url/1" do
    test "appends path to base endpoint url" do
      assert @module.url("users") == "https://api.intercom.io/users"
    end
  end

  describe "authorized_headers/0" do
    test "puts access token into authorization header" do
      assert @module.authorized_headers() ==
               {:ok,
                [
                  Authorization: "Bearer #{@valid_access_token}",
                  Accept: "application/json",
                  "Content-Type": "application/json"
                ]}
    end

    test "returns errors from getting access token" do
      Application.delete_env(:intercom, :access_token)
      assert @module.authorized_headers() == {:error, :no_access_token}
    end
  end
end

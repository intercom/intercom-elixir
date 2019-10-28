defmodule Intercom.API.AuthenticationTest do
  use ExUnit.Case, async: false
  doctest Intercom

  @module Intercom.API.Authentication

  setup do
    on_exit(fn ->
      Application.delete_env(:intercom, :access_token)
    end)
  end

  describe "get_access_token/0" do
    test "makes request when access token is valid" do
      Application.put_env(:intercom, :access_token, "abcde")
      assert @module.get_access_token() == {:ok, "abcde"}
    end

    test "returns correct error message when access token isn't set" do
      assert @module.get_access_token() == {:error, :no_access_token}
    end

    test "returns correct error message when access token is invalid" do
      Application.put_env(:intercom, :access_token, 12345)
      assert @module.get_access_token() == {:error, :invalid_access_token}
    end
  end
end

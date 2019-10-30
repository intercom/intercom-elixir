defmodule Intercom.UsersTest do
  use ExUnit.Case
  import Intercom.APIEndpoint

  @module Intercom.Users

  describe "get/1" do
    test "calls correct rest endpoint" do
      assert_rest_endpoint(:get, "users/12345") do
        @module.get("12345")
      end
    end
  end

  describe "get_by/1" do
    test "calls correct rest endpoint when user_id passed" do
      assert_rest_endpoint(:get, "users?user_id=12345") do
        @module.get_by(user_id: "12345")
      end
    end
  end

  describe "upsert/1" do
    test "calls correct rest endpoint" do
      body = %{user_id: "abcde"}

      assert_rest_endpoint(:post, "users", body) do
        @module.upsert(body)
      end
    end
  end

  describe "list/0" do
    test "calls correct rest endpoint" do
      assert_rest_endpoint(:get, "users") do
        @module.list()
      end
    end
  end

  describe "list_by/1" do
    test "calls correct rest endpoint when email passed" do
      assert_rest_endpoint(:get, "users?email=bob@bob.com") do
        @module.list_by(email: "bob@bob.com")
      end
    end

    test "calls correct rest endpoint when tag_id passed" do
      assert_rest_endpoint(:get, "users?tag_id=12345") do
        @module.list_by(tag_id: "12345")
      end
    end

    test "calls correct rest endpoint when segment_id passed" do
      assert_rest_endpoint(:get, "users?segment_id=12345") do
        @module.list_by(segment_id: "12345")
      end
    end
  end
end

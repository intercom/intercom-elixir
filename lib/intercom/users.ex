defmodule Intercom.Users do
  def get(id) do
    Intercom.API.call_endpoint(:get, "users/#{id}")
  end

  def get_by(user_id: user_id) do
    Intercom.API.call_endpoint(:get, "users?user_id=#{user_id}")
  end

  def get_by(email: email) do
    Intercom.API.call_endpoint(:get, "users?email=#{email}")
  end

  def upsert(user_data) do
    Intercom.API.call_endpoint(:post, "users", user_data)
  end
end

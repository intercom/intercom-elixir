defmodule Intercom.Users do
  def get(id) do
    Intercom.API.call_endpoint(:get, "users/#{id}")
  end

  def get_by(user_id: user_id) do
    Intercom.API.call_endpoint(:get, "users?user_id=#{user_id}")
  end

  def list() do
    Intercom.API.call_endpoint(:get, "users")
  end

  def list_by(email: email) do
    Intercom.API.call_endpoint(:get, "users?email=#{email}")
  end

  def list_by(tag_id: tag_id) do
    Intercom.API.call_endpoint(:get, "users?tag_id=#{tag_id}")
  end

  def list_by(segment_id: segment_id) do
    Intercom.API.call_endpoint(:get, "users?segment_id=#{segment_id}")
  end

  def upsert(user_data) do
    Intercom.API.call_endpoint(:post, "users", user_data)
  end
end

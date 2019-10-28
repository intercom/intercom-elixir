defmodule Intercom.API.Authentication do
  def get_access_token do
    case Application.get_env(:intercom, :access_token, "") do
      "" -> {:error, :no_access_token}
      access_token when not is_binary(access_token) -> {:error, :invalid_access_token}
      access_token -> {:ok, access_token}
    end
  end
end

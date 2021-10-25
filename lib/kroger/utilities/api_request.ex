defmodule Kroger.Utilities.ApiRequest do
  use HTTPoison.Base
  use Phoenix.Controller

  alias Kart.Accounts
  alias Kart.OauthToken

  def call(user_token, path, params) do
    IO.puts("ApiRequest")
    %HTTPoison.Request{
      method: :get,
      url: url_base <> path,
      headers: headers(user_token),
      params: params,
    }
    |> IO.inspect(label: "BLAH")
    |> execute()
  end

  def execute(http_request) do
    IO.inspect("EXECTURE")
    request(http_request)
  end

  defp url_base do
    "https://api.kroger.com/v1"
  end

  defp headers(user_token) do
    IO.puts("headers")
    [
      {"accept", "application/json"},
      {"authorization", "Bearer: #{get_user_access_token(user_token)}"}
    ] 
  end

  defp get_user_access_token(user_token) do
    Accounts.get_user_by_session_token(user_token)
    |> OauthToken.get_access_token_by_user()
  end
end

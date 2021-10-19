defmodule KartWeb.OauthController do
  use KartWeb, :controller

  alias Kart.Repo
  alias Kart.User
  alias Kart.Accounts
  alias Kart.OauthToken

  def index(conn, _params) do
    render(conn, "index.html", token: "Token inserted!")
  end

  defp get_token!(conn) do
    client = Map.merge(client(), %{strategy: OAuth2.Strategy.ClientCredentials})
    user = get_session(conn, :user_token)
           |> Accounts.get_user_by_session_token()
    
    OAuth2.Client.get_token!(client).token.access_token
    |> persist_token(user)
  end

  defp persist_token(response, user) do
    decoded_response = Jason.decode!(response)
    oauth_token = %OauthToken{
      access_token: decoded_response["access_token"],
      user_id: user.id
    }

    case Repo.get_by(OauthToken, user_id: user.id) do
      nil -> Repo.insert(oauth_token)
      token -> Repo.update(token)
    end
  end

  defp refresh_client do
    OAuth2.Client.merge_params(client(), strategy: OAuth2.Strategy.Refresh)
  end 

  defp client do
    OAuth2.Client.new([
      client_id: Application.fetch_env!(:oauth2_credentials, :client_id),
      client_secret: Application.fetch_env!(:oauth2_credentials, :client_secret),
      site: "https://api.kroger.com/v1/connect",
      authorize_url: "/oauth2/authorize",
      token_url: "/oauth2/token",
      redirect_uri: "https://localhost:4000/"
    ])
  end

  defp user(conn) do
    get_session(conn, :user_token)
    |> Accounts.get_user_by_session_token()
  end
end

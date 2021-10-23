defmodule KartWeb.OauthController do
  use KartWeb, :controller
  import Phoenix.Controller

  alias Kart.Repo
  alias Kart.User
  alias Kart.Accounts
  alias Kart.OauthToken

  def index(conn, _params) do
    get_token!(conn)
    render(conn, "index.html", token: "inserted!")
  end

  def authorize(conn, _params) do
    redirect(conn, external: authorize_url!)
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
    oauth_changes = 

    case Repo.get_by(OauthToken, user_id: user.id) do
      nil -> Repo.insert(oauth_token)
      token -> 
        Ecto.Changeset.change(token, access_token: decoded_response["access_token"])
        |> Repo.update
    end
  end

  defp authorize_url! do
    OAuth2.Client.authorize_url!(client())
  end

  defp client do
    OAuth2.Client.new([
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      site: "https://api.kroger.com/v1/connect",
      authorize_url: "/oauth2/authorize",
      token_url: "/oauth2/token",
      redirect_uri: "https://kart.ngrok.io",
      params: %{
        response_type: "code",
        scope: "product.compact"
      }
    ])
  end

  defp user(conn) do
    get_session(conn, :user_token)
    |> Accounts.get_user_by_session_token()
  end
end

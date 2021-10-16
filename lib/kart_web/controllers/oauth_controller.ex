defmodule KartWeb.OauthController do
  use KartWeb, :controller

  alias Kart.Repo
  alias Kart.User

  def index(conn, _params) do
    render(conn, "index.html", token: get_token!())
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

  defp authorize_url! do
    scoped_client = OAuth2.Client.merge_params(client(), params())
    OAuth2.Client.authorize_url!(scoped_client)
  end

  defp get_token! do
    client = Map.merge(client(), %{strategy: OAuth2.Strategy.ClientCredentials})

    OAuth2.Client.get_token!(client).token.access_token
    |> persist_token()
  end

  defp persist_token(response) do
    decoded_response = Jason.decode!(response)
    user = %User{access_token: decoded_response["access_token"]}

    Repo.insert(user)
  end

  defp refresh_client do
    OAuth2.Client.merge_params(client(), strategy: OAuth2.Strategy.Refresh)
  end 

  defp params do
    %{
      response_type: "code",
      scope: "cart.basic:write"
    }
  end
end

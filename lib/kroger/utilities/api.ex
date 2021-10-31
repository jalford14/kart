defmodule Kroger.Utilities.Api do
  use HTTPoison.Base

  alias Kart.Repo
  alias Kart.User
  alias Kart.Accounts
  alias Kart.OauthToken
  alias Kroger.Utilities.Api

  def product_search(params, user_token) do
    %HTTPoison.Request{
      method: :get,
      url: "https://api.kroger.com/v1/products",
      params: params,
      headers: headers(user_token)
    }
    Poison.encode!
    |> execute(user_token)
  end

  def add_to_cart!(body, user_token) do
    %HTTPoison.Request{
      method: :put,
      url: "https://api.kroger.com/v1/cart/add",
      body: Jason.encode!(body),
      headers: headers(user_token)
    }
    |> execute(user_token)
  end

  def get_user_access_token(user_token) do
    Accounts.get_user_by_session_token(user_token)
    |> OauthToken.get_access_token_by_user()
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client())
  end

  def get_token!(user_token, code) do
    user = Accounts.get_user_by_session_token(user_token)

    OAuth2.Client.get_token!(client(), code: code).token
    |> persist_token(user)
  end

  defp execute(http_request, user_token) do
    case request(http_request) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"data" => decoded_body} = Jason.decode!(body)
        {:ok, decoded_body}

      {:ok, %HTTPoison.Response{status_code: 204, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 401} = error} ->
        refresh_token(user_token)
        decoded_body = Jason.decode!(error.body)
        {:error, decoded_body["error_description"]}

      {:error, e} ->
        {:error, e.body["error_description"]}
    end
  end

  defp refresh_token(user_token) do
    user = get_user_by_session_token(user_token)
    oauth_token_record = Repo.get_by(OauthToken, user_id: user.id)

    client
    |> Map.put(:token, %{refresh_token: oauth_token_record.refresh_token})
    |> OAuth2.Client.refresh_token()
  end

  defp persist_token(response, user) do
    oauth_token = %OauthToken{
      access_token: response.access_token,
      refresh_token: response.refresh_token,
      user_id: user.id
    }

    oauth_changes =
      case Repo.get_by(OauthToken, user_id: user.id) do
        nil ->
          Repo.insert(oauth_token)

        token_record ->
          Ecto.Changeset.change(token_record, %{
            access_token: response.access_token,
            refresh_token: response.refresh_token
          })
          |> Repo.update()
      end
  end

  defp get_user_by_session_token(user_token) do
    Accounts.get_user_by_session_token(user_token)
  end

  defp format_response(%{"data" => body} = _response) do
  end

  defp client do
    OAuth2.Client.new(
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      site: "https://api.kroger.com/v1/connect",
      authorize_url: "/oauth2/authorize",
      token_url: "/oauth2/token",
      redirect_uri: "https://kart.ngrok.io/oauth/callback",
      serializers: %{"application/json" => Jason},
      params: %{
        response_type: "code",
        scope: "product.compact cart.basic:write"
      }
    )
  end

  defp headers(user_token) do
    [
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{get_user_access_token(user_token)}"}
    ]
  end
end

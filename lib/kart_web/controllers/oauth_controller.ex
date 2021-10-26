defmodule KartWeb.OauthController do
  use KartWeb, :controller
  import Phoenix.Controller

  alias Kart.Repo
  alias Kart.User
  alias Kart.Accounts
  alias Kart.OauthToken
  alias Kroger.Utilities.Api

  def index(conn, _params) do
    render(conn, "index.html", token: "inserted!")
  end

  def callback(conn, params) do
    case params do
      %{"code" => code} ->
        get_session(conn, :user_token)
        |> Api.get_token!(code)

      _ ->
        redirect(conn, to: "/")
    end

    render(conn, "index.html", token: "inserted!")
  end

  def authorize(conn, _params) do
    redirect(conn, external: Api.authorize_url!())
  end
end

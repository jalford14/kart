defmodule KartWeb.GroceryListsController do
  use KartWeb, :controller
  import Phoenix.Controller

  alias Kart.GroceryList
  alias Kart.Accounts

  def index(conn, _params) do
    lists =
      get_session(conn, :user_token)
      |> Accounts.get_user_by_session_token()
      |> GroceryList.get_lists_by_user()

    render(conn, "index.html", lists: lists)
  end
end

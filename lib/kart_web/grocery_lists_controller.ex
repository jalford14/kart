defmodule KartWeb.GroceryListsController do
  use KartWeb, :controller
  import Phoenix.Controller

  alias Kart.GroceryList
  alias Kart.GroceryItem
  alias Kroger.AddToCart
  alias Kart.Accounts

  def index(conn, _params) do
    lists =
      get_session(conn, :user_token)
      |> Accounts.get_user_by_session_token()
      |> GroceryList.get_lists_by_user()

    render(conn, "index.html", lists: lists)
  end

  def add_to_cart(conn, _params) do
    GroceryItem.get_list_items_by_id(2)
    |> AddToCart.call(get_session(conn, :user_token))

    redirect(conn, external: "https://www.kroger.com/cart")
  end
end

defmodule KartWeb.CartController do
  use KartWeb, :controller
  import Phoenix.Controller

  alias Kroger.AddToCart
  alias Kart.GroceryItem

  def index(conn, _params) do
    resp =
      GroceryItem.get_list_items_by_id(2)
      |> AddToCart.call(get_session(conn, :user_token))

    render(conn, "show.html", items: resp)
  end
end

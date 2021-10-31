defmodule KartWeb.GroceryItemsController do
  use KartWeb, :controller
  import Phoenix.Controller

  alias Kart.GroceryItem

  def show(conn, %{"list_id" => list_id}) do
    items = GroceryItem.get_list_items_by_id(list_id)

    render(conn, "show.html", items: items)
  end
end

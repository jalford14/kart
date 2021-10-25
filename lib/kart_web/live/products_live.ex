defmodule KartWeb.ProductsLive do
  use KartWeb, :live_view

  alias Kroger.ProductSearch

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    {:ok, assign(socket, query: nil, products: [], user_token: user_token)}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    products = socket.assigns[:user_token]
               |> ProductSearch.call(%{"filter.term" => query, "filter.locationId" => "01100461", "filter.limit" => 15})

    {:noreply, assign(socket, products: products)}
  end

  def render(assigns) do
    ~L"""
    <form phx-change="search">
      <input phx-debounce="1000" type="text" name="query" value="<%= @query %>" placeholder="Search..."/>
      <datalist id="products">
        <%= for product <- @products do %>
          <option value={product}><%= product %></option>
        <% end %>
      </datalist>
    </form>
    """
  end
end

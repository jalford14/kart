defmodule KartWeb.ProductsLive do
  use KartWeb, :live_view

  alias Kroger.ProductSearch

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: nil, products: [])}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    products = ProductSearch.call(query, "01100461")
    {:noreply, assign(socket, products: products)}
  end

  def render(assigns) do
    ~L"""
    <form phx-change="search">
      <input phx-debounce="2000" type="text" name="query" value="<%= @query %>" placeholder="Search..."/>
      <datalist id="products">
        <%= for product <- @products do %>
          <option value={product}><%= product %></option>
        <% end %>
      </datalist>
    </form>
    """
  end
end

defmodule KartWeb.ProductsLive do
  use KartWeb, :live_view

  alias Kroger.ProductSearch

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    {:ok, assign(socket, query: nil, products: [], error: nil, user_token: user_token)}
  end

  @impl true
  def handle_event("search", %{"query" => ""}, socket) do
    {:noreply, assign(socket, products: [])}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    products = socket.assigns[:user_token]
               |> ProductSearch.call(%{"filter.term" => query, "filter.locationId" => "01100461", "filter.limit" => 5})

    case products do
      {:ok, products} ->
        {:noreply, assign(socket, products: products)}
        
      {:error, error} -> 
        {:noreply, assign(socket, error: error)}
    end
  end

  def render(assigns) do
    ~L"""
    <form phx-change="search">
      <input phx-debounce="1000" type="text" name="query" value="<%= @query %>" placeholder="Search..."/>
      <p> Products </p>
      <%= for product <- @products do %>
        <%= product["brand"] %>
        <%= product["description"] %>
        <%= product["productId"] %>
        <%= for image <- product["images"] do %>
          <%= if image["featured"] do %>
            <%= for preview <- image["sizes"] do %>
              <%= if preview["size"] == "small" do %>
                <img src="<%= preview["url"] %>">
              <% end %>
            <% end %>
          <% end %>
        <% end %>
      <% end %>
      <%= if @error do %>
        <h1>Errors</h1>
        <p style="color: red"><%= @error %></p>
      <% end %>
    </form>
    """
  end
end

defmodule KartWeb.ProductsLive do
  use KartWeb, :live_view

  alias Kroger.ProductSearch
  alias Kroger.GroceryList
  alias Kart.GroceryItem

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
    products =
      socket.assigns[:user_token]
      |> ProductSearch.call(%{
        "filter.term" => query,
        "filter.locationId" => "01100461",
        "filter.limit" => 5
      })

    case products do
      {:ok, products} ->
        {:noreply, assign(socket, products: products)}

      {:error, error} ->
        {:noreply, assign(socket, error: error)}
    end
  end

  @impl true
  def handle_event(
        "add-cart",
        %{
          "id" => product_id,
          "brand" => brand,
          "description" => description,
          "img" => image_url
        },
        socket
      ) do
    user =
      socket.assigns[:user_token]
      |> Kart.Accounts.get_user_by_session_token()

    %GroceryItem{
      grocery_list_id: 2,
      product_id: product_id,
      brand: brand,
      description: description,
      image_url: image_url
    }
    |> Kart.Repo.insert()

    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <form phx-change="search">
      <input phx-debounce="500" type="text" name="query" value="<%= @query %>" placeholder="Search Products..."/>
      <%= for product <- @products do %>
        <p>
          <%= product["brand"] %>
          <%= product["description"] %>
          <%= product["productId"] %>
          <%= for image <- product["images"] do %>
            <%= if image["featured"] do %>
              <%= for preview <- image["sizes"] do %>
                <%= if preview["size"] == "small" do %>
                  <a phx-click="add-cart"
                     phx-value-id="<%= product["productId"] %>"
                     phx-value-brand="<%= product["brand"] %>"
                     phx-value-description="<%= product["description"] %>"
                     phx-value-img="<%=preview["url"] %>"
                     style="cursor: pointer"
                  >
                  <img src="<%= preview["url"] %>">
                <% end %>
              <% end %>
            <% end %>
          <% end %>
          </a>
        </p>
      <% end %>

      <%= if @error do %>
        <h1>Errors</h1>
        <a href="/oauth/authorize">
          <p style="color: red"><%= @error %></p>
        </a>
      <% end %>
    </form>
    """
  end
end

defmodule KartWeb.ItemsLive do
  use KartWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    KartWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, position: "start")}
  end

  @impl true
  def handle_event("board-update", %{"new_position" => fen}, socket) do
    state = %{position: fen}
    KartWeb.Endpoint.broadcast_from(self(), @topic, fen, state)
    {:noreply, assign(socket, state)}
  end

  @impl true
  def handle_event("reset", _value, socket) do
    {:noreply, assign(socket, position: "start")}
  end

  @impl true
  def handle_info(%{topic: @topic, payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  def render(assigns) do
    ~L"""
    <button
        phx-click="reset">
      Reset
    </button>
    <chess-board
        id="board"
        phx-hook="MoveMade"
        style="width: 50%; margin: auto;"
        position="<%= @position %>"
        draggable-pieces>
    </chess-board>
    """
  end
end

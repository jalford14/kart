defmodule KartWeb.PageController do
  use KartWeb, :controller

  def index(conn, params) do
    render(conn, "index.html")
  end
end

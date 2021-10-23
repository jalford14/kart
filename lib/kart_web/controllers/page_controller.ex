defmodule KartWeb.PageController do
  use KartWeb, :controller

  def index(conn, params) do
    IO.inspect(params)
    case params do
      %{"code" => code} -> IO.puts("Woo!")
    end
    render(conn, "index.html")
  end
end

defmodule KartWeb.OauthView do
  use KartWeb, :view

  def render("index.json", %{token: token}) do
    Jason.decode!(token)
  end
end

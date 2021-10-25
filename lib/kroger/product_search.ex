defmodule Kroger.ProductSearch do
  alias Kroger.Utilities.Api
  alias Kart.OauthToken

  def call(user_token, params) do
    Api.make_request(user_token, "/products", params)
  end
end

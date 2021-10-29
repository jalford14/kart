defmodule Kroger.ProductSearch do
  alias Kroger.Utilities.Api
  alias Kart.OauthToken

  def call(user_token, params) do
    Api.product_search(params, user_token)
  end
end

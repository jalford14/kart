defmodule Kroger.Utilities.ApiTest do
  use KartWeb.ConnCase
  use ExUnit.Case, async: true

  import Mox
  setup :verify_on_exit!

  describe "product_search/2" do
    setup do
      %{
        product_search_response: %HTTPoison.Response{
          status_code: 200,
          body:
            "{\"data\":[{\"aisleLocations\":\"test\",\"brand\":\"Kroger\",\"categories\":\"test\",\"countryOrigin\":\"United States\",\"description\":\"Kroger 2% Reduced Fat Milk\",\"images\":\"test\",\"itemInformation\":\"test\",\"items\":\"test\",\"productId\":\"0001111041700\",\"temperature\":\"test\",\"upc\":\"0001111041700\"}]}"
        }
      }
    end

    test "returns a list of products", %{product_search_response: response} do
      expect(HTTPoison.MockBase, :request, fn _ -> {:ok, response} end)
      expect(Kart.MockOauthToken, :get_access_token_by_user, fn _ -> "token" end)
      decoded_body = Jason.decode!(response.body)

      assert {:ok, decoded_body} = Kroger.Utilities.Api.product_search("params", "token")
    end
  end

  describe "add_to_cart!/2" do
    setup do
      %{
        add_to_cart_response: %HTTPoison.Response{
          status_code: 204,
          body: %{}
        }
      }
    end

    test "add GroceryItem's to user's Kroger cart", %{add_to_cart_response: response} do
      expect(HTTPoison.MockBase, :request, fn _ -> {:ok, response} end)
      expect(Kart.MockOauthToken, :get_access_token_by_user, fn _ -> "token" end)

      assert {:ok, %{}} = Kroger.Utilities.Api.add_to_cart!("body", "token")
    end
  end
end

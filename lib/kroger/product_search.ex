defmodule Kroger.ProductSearch do
  alias Kroger.Utilities.ApiRequest

  def call(term, location_id) do
  end

  defp url(term, location_id) do
    "https://api.kroger.com/v1/products?filter.term=#{term}&filter.locationId=#{location_id}"
  end
end

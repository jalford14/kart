defmodule Kroger.ProductSearch do
  alias Kroger.Utilities.ApiRequest

  def call(term, location_id, limit \\ 15) do
    url(term, location_id, limit)
    |> HTTPoison.get
  end

  defp url(term, location_id, limit) do
    "https://api.kroger.com/v1/products?filter.term=#{term}&filter.locationId=#{location_id}?limit=#{limit}"
  end
end

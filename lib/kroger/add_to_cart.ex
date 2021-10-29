defmodule Kroger.AddToCart do
  alias Kroger.Utilities.Api
  alias Kroger.AddToCart

  def call(items, user_token) do
    extract_upcs(items, [])
    |> format_request()
    |> Api.add_to_cart!(user_token)
  end

  defp extract_upcs([item | remaining_items], upcs) do
    extract_upcs(remaining_items, upcs ++ [item.product_id])
  end

  defp extract_upcs([], upcs), do: upcs

  defp format_request(upcs) do
    %{
      "items" => ids_list(upcs, [])
    }
  end

  defp ids_list([upc | remaining_upcs], items) do
    formatted_item = items ++ [%{"quantity" => 1, "upc" => upc}]
    ids_list(remaining_upcs, formatted_item)
  end

  defp ids_list([], formatted_items), do: formatted_items
end

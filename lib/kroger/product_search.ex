defmodule Kroger.ProductSearch do
  alias Kroger.Utilities.ApiRequest

  def call(user_token, params) do
    IO.puts("ProductSearch")
    ApiRequest.call(user_token, "/products", params) 
    |> IO.inspect(label: "bhadhffiahefiawe")
  end
end

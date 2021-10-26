defmodule Kart.GroceryList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "grocery_lists" do
    field :brand, :string
    field :description, :string
    field :image_url, :string
    field :product_id, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(grocery_list, attrs) do
    grocery_list
    |> cast(attrs, [:product_id, :brand, :description, :image_url])
    |> validate_required([:product_id, :brand, :description, :image_url])
  end
end

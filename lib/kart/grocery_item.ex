defmodule Kart.GroceryItem do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  alias Kart.Repo

  schema "grocery_items" do
    field :brand, :string
    field :description, :string
    field :image_url, :string
    field :product_id, :string
    field :grocery_list_id, :id

    timestamps()
  end

  def get_list_items_by_id(list_id) do
    query =
      from item in __MODULE__,
        where: item.grocery_list_id == ^list_id

    Repo.all(query)
  end

  @doc false
  def changeset(grocery_item, attrs) do
    grocery_item
    |> cast(attrs, [:product_id, :brand, :description, :image_url, :grocery_list_id])
    |> validate_required([:product_id, :brand, :description, :image_url, :grocery_list_id])
  end
end

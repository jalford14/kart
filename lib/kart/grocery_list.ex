defmodule Kart.GroceryList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "grocery_lists" do
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(grocery_list, attrs) do
    grocery_list
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end

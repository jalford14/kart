defmodule Kart.GroceryList do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Kart.Repo

  schema "grocery_lists" do
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  def get_lists_by_user(user) do
    query =
      from list in __MODULE__,
        where: list.user_id == ^user.id

    Repo.all(query)
  end

  @doc false
  def changeset(grocery_list, attrs) do
    grocery_list
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end

defmodule Kart.Repo.Migrations.CreateGroceryLists do
  use Ecto.Migration

  def change do
    create table(:grocery_lists) do
      add :product_id, :string
      add :brand, :string
      add :description, :text
      add :image_url, :string
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:grocery_lists, [:user_id])
  end
end

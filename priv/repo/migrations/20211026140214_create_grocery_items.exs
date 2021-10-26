defmodule Kart.Repo.Migrations.CreateGroceryItems do
  use Ecto.Migration

  def change do
    create table(:grocery_items) do
      add :product_id, :string
      add :brand, :string
      add :description, :text
      add :image_url, :string
      add :grocery_list_id, references(:grocery_lists, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:grocery_items, [:grocery_list_id])
  end
end

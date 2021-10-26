defmodule Kart.Repo.Migrations.CreateGroceryLists do
  use Ecto.Migration

  def change do
    create table(:grocery_lists) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:grocery_lists, [:user_id])
  end
end

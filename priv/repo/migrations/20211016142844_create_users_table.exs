defmodule Kart.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :access_token, :string
      add :refresh_token, :string
    end
  end
end

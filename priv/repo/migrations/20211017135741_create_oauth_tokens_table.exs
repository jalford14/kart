defmodule Kart.Repo.Migrations.CreateOauthTokens do
  use Ecto.Migration

  def change do
    create table(:oauth_tokens) do
      add :access_token, :text
      add :refresh_token, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:oauth_tokens, [:user_id])
  end
end

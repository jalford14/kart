defmodule Kart.OauthToken do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query, warn: false
  alias Kart.Repo

  schema "oauth_tokens" do
    field :access_token, :string
    field :refresh_token, :string
    field :user_id, :id

    timestamps()
  end

  @callback get_access_token_by_user(Ecto.Schema.t()) :: String.t()
  def get_access_token_by_user(user) do
    Repo.get_by(Kart.OauthToken, user_id: user.id).access_token
  end

  @doc false
  def changeset(oauth_token, attrs) do
    oauth_token
    |> cast(attrs, [:access_token, :refresh_token])
    |> validate_required([:access_token, :refresh_token])
  end
end

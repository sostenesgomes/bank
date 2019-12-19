defmodule Bank.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :agency_id, :integer
    field :code, :integer
    field :digit, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:code, :digit, :agency_id, :user_id])
    |> validate_required([:code, :digit, :agency_id, :user_id])
  end
end

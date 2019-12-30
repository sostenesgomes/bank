defmodule Bank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Accounts.Account

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    has_one :account, Account

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_length(:name, min: 2)
    |> validate_length(:password, is: 6)
    |> validate_format(:email, ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/)
    |> unique_constraint(:email)
  end
end

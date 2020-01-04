defmodule Bank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Agencies.Agency
  alias Bank.Users.User

  schema "accounts" do
    field :code, :string
    field :digit, :integer
    field :balance, :float
    belongs_to :user, User
    belongs_to :agency, Agency
    
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:code, :digit, :balance])
    |> validate_required([:code, :digit, :balance])
  end
end

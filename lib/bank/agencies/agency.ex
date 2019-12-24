defmodule Bank.Agencies.Agency do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Accounts.Account

  schema "agencies" do
    field :code, :integer
    field :digit, :integer
    field :name, :string
    has_many :account, Account

    timestamps()
  end

  @doc false
  def changeset(agency, attrs) do
    agency
    |> cast(attrs, [:name, :code, :digit])
    |> validate_required([:name, :code, :digit])
  end
end

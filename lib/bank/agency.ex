defmodule Bank.Agency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "agencies" do
    field :code, :integer
    field :digit, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(agency, attrs) do
    agency
    |> cast(attrs, [:name, :code, :digit])
    |> validate_required([:name, :code, :digit])
  end
end

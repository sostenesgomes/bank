defmodule Bank.Operation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "operations" do
    field :code, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(operation, attrs) do
    operation
    |> cast(attrs, [:code, :title])
    |> validate_required([:code, :title])
  end
end

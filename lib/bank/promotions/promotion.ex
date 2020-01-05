defmodule Bank.Promotions.Promotion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "promotions" do
    field :code, :string
    field :amount, :float
    field :is_active, :boolean

    timestamps()
  end

  @doc false
  def changeset(promotion, attrs) do
    promotion
    |> cast(attrs, [:code, :amount, :is_active])
    |> validate_required([:code, :amount, :is_active])
    |> validate_number(:amount, greater_than: 0)
  end
end

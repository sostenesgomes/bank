defmodule Bank.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :account_id, :integer
    field :ammount, :decimal
    field :new_account_ammount, :decimal
    field :operation_id, :integer
    field :prev_account_value, :decimal
    field :to_account_id, :integer

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:ammount, :prev_account_value, :new_account_ammount, :operation_id, :account_id, :from_account_id, :to_account_id])
    |> validate_required([:ammount, :prev_account_value, :new_account_ammount, :operation_id, :account_id, :from_account_id, :to_account_id])
  end
end

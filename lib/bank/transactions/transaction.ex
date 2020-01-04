defmodule Bank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Accounts.Account
  alias Bank.Operations.Operation

  schema "transactions" do
    field :amount, :float
    field :prev_account_balance, :float
    field :new_account_balance, :float
    belongs_to :operation, Operation
    belongs_to :source_account, Account, foreign_key: :account_id
    belongs_to :target_account, Account, foreign_key: :target_account_id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :prev_account_balance, :new_account_balance])
    |> validate_required([:amount, :prev_account_balance, :new_account_balance])
  end
end

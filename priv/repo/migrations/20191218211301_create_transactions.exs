defmodule Bank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal, null: false
      add :prev_account_balance, :decimal, null: false
      add :new_account_balance, :decimal, null: false
      add :operation_id, references(:operations), null: false
      add :account_id, references(:accounts), null: false
      add :target_account_id, references(:accounts)

      timestamps()
    end

  end
end

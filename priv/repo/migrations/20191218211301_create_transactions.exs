defmodule Bank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :ammount, :decimal, null: false
      add :prev_account_ammount, :decimal, null: false
      add :new_account_ammount, :decimal, null: false
      add :operation_id, references(:operations), null: false
      add :account_id, references(:accounts), null: false
      add :from_account_id, references(:accounts)
      add :to_account_id, references(:accounts)

      timestamps()
    end

  end
end

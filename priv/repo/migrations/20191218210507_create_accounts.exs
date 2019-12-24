defmodule Bank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :decimal, null: false
      add :code, :integer, null: false
      add :digit, :integer, null: false
      add :agency_id, references(:agencies), null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create unique_index(:accounts, [:code])
  end
end

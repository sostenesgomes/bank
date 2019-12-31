defmodule Bank.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create table(:operations) do
      add :code, :integer, null: false
      add :title, :string, null: false

      timestamps()
    end

    create unique_index(:operations, [:code])
    create unique_index(:operations, [:title])
  end
end

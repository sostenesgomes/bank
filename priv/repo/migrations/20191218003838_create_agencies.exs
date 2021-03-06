defmodule Bank.Repo.Migrations.CreateAgencies do
  use Ecto.Migration

  def change do
    create table(:agencies) do
      add :name, :string, null: false
      add :code, :integer, null: false
      add :digit, :integer, null: false

      timestamps()
    end

    create unique_index(:agencies, [:name])
    create unique_index(:agencies, [:code])
  end
end

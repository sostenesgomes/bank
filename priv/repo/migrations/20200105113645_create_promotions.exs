defmodule Bank.Repo.Migrations.CreatePromotions do
  use Ecto.Migration

  def change do
    create table(:promotions) do
      add :code, :string, null: false
      add :amount, :float, null: false
      add :is_active, :boolean, null: false

      timestamps()
    end

    create unique_index(:promotions, [:code])
  end
end

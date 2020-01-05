defmodule Bank.Repo.Migrations.CreateEmailsLog do
  use Ecto.Migration

  def change do
    create table(:emails_log) do
      add :bamboo_struct, :map
      add :status, :integer

      timestamps()
    end

  end
end

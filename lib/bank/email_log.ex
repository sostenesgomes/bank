defmodule Bank.EmailLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emails_log" do
    field :bamboo_struct, :map
    field :status, :integer

    timestamps()
  end

  @doc false
  def changeset(email_log, attrs) do
    email_log
    |> cast(attrs, [:bamboo_struct, :status])
    |> validate_required([:bamboo_struct, :status])
  end
end

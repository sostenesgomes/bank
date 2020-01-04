defmodule BankWeb.TransactionController do
  use BankWeb, :controller

  alias Bank.{Repo, Transactions, Accounts}
  alias Bank.Transactions.Transaction
  alias Bank.Accounts.Account

  action_fallback BankWeb.FallbackController

  def transfer(conn, %{"transfer" => transfer_params}) do
    with {:ok, _} <- validate_transfer_params(transfer_params),
         %Account{} = source_account <- Guardian.Plug.current_resource(conn) |> Repo.preload(:account) |> Map.get(:account),
         {:ok, target_account} <- Accounts.get_account_by_code_dg(transfer_params["target_account_code"], transfer_params["target_account_digit"]),
         {:ok, %Transaction{} = source_transaction, %Transaction{} = target_transaction} <- Transactions.create_transfer(source_account, target_account, transfer_params["amount"]) do
      conn
        |> put_status(:created)
        |> render("transfer.json", %{source_transaction: source_transaction, target_transaction: target_transaction})
    end
  end

  defp validate_transfer_params(params) do
    types = %{target_account_code: :string, target_account_digit: :integer, amount: :float}
    changeset = 
      {%{}, types}
      |> Ecto.Changeset.cast(params, Map.keys(types))
      |> Ecto.Changeset.validate_required([:target_account_code, :target_account_digit, :amount])
  
    case changeset.valid? do
      true -> {:ok, true}
      false -> {:error, changeset}
    end
  end  
end

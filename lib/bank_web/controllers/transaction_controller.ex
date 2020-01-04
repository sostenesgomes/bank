defmodule BankWeb.TransactionController do
  use BankWeb, :controller

  alias Bank.{Repo, Transactions, Accounts}
  alias Bank.Transactions.Transaction
  alias Bank.Accounts.Account

  action_fallback BankWeb.FallbackController

  def transfer(conn, %{"transfer" => transfer_params }) do
    with %Account{} = source_account <- Guardian.Plug.current_resource(conn) |> Repo.preload(:account) |> Map.get(:account),
         {:ok, target_account} <- Accounts.get_account_by_code_dg(transfer_params["target_account_code"], transfer_params["target_account_digit"]),
         {:ok, data} <- Transactions.create_transfer(target_account, source_account, transfer_params["amount"]) do
      conn
      |> put_status(:created)
      |> render("transfer.json", %{data: data})
    end
  end

end

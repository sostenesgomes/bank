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

  def cashout(conn, %{"cashout" => cashout_params}) do
    with {:ok, _} <- validate_cashout_params(cashout_params),
         %Account{} = source_account <- Guardian.Plug.current_resource(conn) |> Repo.preload(:account) |> Map.get(:account),
         {:ok, %Transaction{} = cashout_transaction} <- Transactions.create_cashout(source_account, cashout_params["amount"]) do
      
      BankWeb.Email.cashout_email(Guardian.Plug.current_resource(conn), cashout_transaction.amount)
        |> log_cashout_email()

      conn
        |> put_status(:created)
        |> render("cashout.json", %{cashout_transaction: cashout_transaction})
    end
  end

  defp validate_transfer_params(params) do
    types = %{target_account_code: :string, target_account_digit: :integer, amount: :float}
    changeset = 
      {%{}, types}
        |> Ecto.Changeset.cast(params, Map.keys(types))
        |> Ecto.Changeset.validate_required([:target_account_code, :target_account_digit, :amount])
        |> Ecto.Changeset.validate_number(:amount, greater_than: 0)

    case changeset.valid? do
      true -> {:ok, true}
      false -> {:error, changeset}
    end
  end
  
  defp validate_cashout_params(params) do
    types = %{amount: :float}
    changeset = 
      {%{}, types}
        |> Ecto.Changeset.cast(params, Map.keys(types))
        |> Ecto.Changeset.validate_required([:amount])
        |> Ecto.Changeset.validate_number(:amount, greater_than: 0)
  
    case changeset.valid? do
      true -> {:ok, true}
      false -> {:error, changeset}
    end
  end
  
  defp log_cashout_email(email) do
    %Bank.EmailLog{}
      |> Bank.EmailLog.changeset(%{bamboo_struct: Jason.encode(email), status: 1})
      |> Repo.insert()
  end    

end

defmodule Bank.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  
  alias Ecto.Multi
  alias Bank.Repo
  alias Bank.{Accounts, Transactions, Promotions, Operations}
  alias Bank.Users.User
  alias Bank.Operations.Operation

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single User by email.

  ## Examples

      iex> get_user_by_email(email@bank.com)
      {:ok, %User{}}

      iex> get_user_by_email(notfound@bank.com)
      {:error, :not_found}
  """
  def get_user_by_email(email) do 
    Repo.get_by(User, email: email) 
    |> Repo.preload(:account)
    |> case do 
        nil ->
          {:error, :not_found}
        user ->
          {:ok, user}  
      end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  def create_user_account(agency, attrs \\ %{}) do
    Multi.new()
      |> Multi.run(:user, fn _, _ ->
        create_user(attrs)
      end)  
      |> Multi.run(:account, fn _, %{user: user} ->
        Accounts.create_account(user, agency)
      end)
      |> Multi.run(:some_transaction, fn _, %{account: account} ->
        account_receive_cash_on_register(account)
      end)  
      |> Repo.transaction()
      |> case do
        {:ok, %{user: user, account: account}} ->
          {:ok, user, account}
  
        {:error, _, failed_value, _} ->
          {:error, failed_value}
      end
  end
  
  defp account_receive_cash_on_register(account) do
    code = "account_receive_cash_on_register"

    with {:ok, promotion} <- Promotions.get_promotion_by_code(code),
         {:ok, %Operation{} = operation_transfer_received} <- Operations.get_operation_by_code(2) do
      
      promotion.is_active
        |> case do
          true ->
            prev_balance = account.balance
            new_balance = account.balance + promotion.amount
            transaction_data = %{amount: promotion.amount, prev_account_balance: prev_balance, new_account_balance: new_balance}
            
            {:ok, source_account} = Accounts.update_balance(account, %{balance: promotion.amount})
            
            Transactions.create_transfer_received(transaction_data, operation_transfer_received, source_account)
            
          false -> 
            {:ok, false}
        end
    else
      _ -> 
        {:ok, false}
    end  
  end  
end

defmodule Bank.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Bank.{Repo, Operations, Accounts}
  alias Ecto.{Multi, Changeset}
  alias Bank.Transactions.Transaction
  alias Bank.Operations.Operation
  alias Bank.Accounts.Account

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

    @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs, %Operation{} = operation, %Account{} = source_account, %Account{} = target_account \\ nil) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:operation, operation)
    |> Ecto.Changeset.put_assoc(:source_account, source_account)
    |> Ecto.Changeset.put_assoc(:target_account, target_account)
    |> Repo.insert()
  end

  def create_transfer_sent(attrs, %Operation{} = operation, %Account{} = source_account, %Account{} = target_account) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:operation, operation)
    |> Ecto.Changeset.put_assoc(:source_account, source_account)
    |> Ecto.Changeset.put_assoc(:target_account, target_account)
    |> Repo.insert()
  end

  def create_transfer_received(attrs, %Operation{} = operation, %Account{} = account) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:operation, operation)
    |> Ecto.Changeset.put_assoc(:source_account, account)
    |> Repo.insert()
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer(%Account{} = source_account, %Account{} = target_account, amount) do
    with {:ok, %Operation{} = transferSend} <- Operations.get_operation_by_code(1),
         {:ok, %Operation{} = transferReceived} <- Operations.get_operation_by_code(2) do

      source_prev_balance = target_account.balance
      source_new_balance = source_prev_balance - amount

      target_prev_balance = target_account.balance
      target_new_balance = target_prev_balance + amount
      
      source_transaction = %{amount: amount, prev_account_balance: source_prev_balance, new_account_balance: source_new_balance}
      target_transaction = %{amount: amount, prev_account_balance: target_prev_balance, new_account_balance: target_new_balance}
          
      Multi.new()
      |> Multi.run(:source_transaction, fn _, _ ->
        create_transfer_sent(source_transaction, transferSend, source_account, target_account)
      end)
      |> Multi.run(:target_transaction, fn _, _ ->
        create_transfer_received(target_transaction, transferReceived, target_account)
      end)
      |> Multi.run(:remove_amount, fn _, _ ->
        Accounts.update_balance(source_account, %{balance: source_new_balance})
      end)
      |> Multi.run(:add_amount, fn _, _ ->
        Accounts.update_balance(target_account, %{balance: target_new_balance})
      end)  
      |> Repo.transaction()
      |> case do
        {:ok, %{source_transaction: source_transaction, target_transaction: target_transaction}} ->
          {:ok, %{id: 1}}
  
        {:error, _, failed_value, _} ->
          {:error, failed_value}
      end
    end

  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end
end

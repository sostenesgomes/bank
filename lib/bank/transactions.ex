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
  Creates a transfer.

  ## Examples

      iex> create_transaction(%Account{} = source_account, %Account{} = target_account, amount)
      {:ok, %Transaction{}}

      iex> create_transaction(%Account{} = source_account, %Account{} = target_account, 0)
      {:error, failed_value}

  """
  def create_transfer(%Account{} = source_account, %Account{} = target_account, amount) do
    with {:ok, %Operation{} = transfer_send} <- Operations.get_operation_by_code(1),
         {:ok, %Operation{} = transfer_received} <- Operations.get_operation_by_code(2) do

      source_prev_balance = source_account.balance
      source_new_balance = source_prev_balance - amount

      target_prev_balance = target_account.balance
      target_new_balance = target_prev_balance + amount
      
      source_data = %{amount: -amount, prev_account_balance: source_prev_balance, new_account_balance: source_new_balance}
      target_data = %{amount: amount, prev_account_balance: target_prev_balance, new_account_balance: target_new_balance}
          
      Multi.new()
      |> Multi.run(:source_transaction, fn _, _ ->
        create_transfer_sent(source_data, transfer_send, source_account, target_account)
      end)
      |> Multi.run(:target_transaction, fn _, _ ->
        create_transfer_received(target_data, transfer_received, target_account)
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
          {:ok, source_transaction, target_transaction}
  
        {:error, _, failed_value, _} ->
          {:error, failed_value}
      end
    end

  end

  def create_cashout_register(attrs, %Operation{} = operation, %Account{} = account) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:operation, operation)
    |> Ecto.Changeset.put_assoc(:source_account, account)
    |> Repo.insert()
  end

  @doc """
  Creates a cashout

  ## Examples

      iex> create_cashout(%Account{} = source_account, amount)
      
      {:ok, %Transaction{}}

      iex> create_cashout(%Account{} = source_account, 0)
      {:error, failed_value}

  """
  def create_cashout(%Account{} = source_account, amount) do
    with {:ok, %Operation{} = operation_cashout} <- Operations.get_operation_by_code(3) do

      source_prev_balance = source_account.balance
      source_new_balance = source_prev_balance - amount
      
      source_data = %{amount: -amount, prev_account_balance: source_prev_balance, new_account_balance: source_new_balance}
          
      Multi.new()
      |> Multi.run(:cashout_transaction, fn _, _ ->
        create_cashout_register(source_data, operation_cashout, source_account)
      end)
      |> Multi.run(:add_amount, fn _, _ ->
        Accounts.update_balance(source_account, %{balance: source_new_balance})
      end)  
      |> Repo.transaction()
      |> case do
        {:ok, %{cashout_transaction: cashout_transaction}} ->
          {:ok, cashout_transaction}
  
        {:error, _, failed_value, _} ->
          {:error, failed_value}
      end
    end
  end

end

defmodule Bank.TransactionsTest do
  use Bank.DataCase

  alias Bank.{Transactions, Operations, Accounts}
  
  describe "transactions" do
    alias Bank.Transactions.Transaction

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    @user_source %{name: "User Source", email: "user_source@transactiontest.com", password: "passwd"}
    @user_target %{name: "User Target", email: "user_target@transactiontest.com", password: "passwd"}

    @agency_attrs %{name: "Agency", code: 17815, digit: 1}

    test "create_transfer_sent/4 with valid data creates a transaction" do
      operation_fixture()
      
      amount = -100.0
      prev_balance = 0
      new_balance = 100.0

      attrs = %{amount: amount, prev_account_balance: prev_balance, new_account_balance: new_balance}
      agency = agency_fixture(@agency_attrs)
      {:ok, operation} = Operations.get_operation_by_code(1) 

      user_source = user_fixture(@user_source)
      source_account = account_fixture(user_source, agency)

      user_target = user_fixture(@user_target)
      target_account = account_fixture(user_target, agency)

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transfer_sent(attrs, operation, source_account, target_account)
      
      assert transaction.account_id == source_account.id
      assert transaction.target_account_id == target_account.id

      assert transaction.prev_account_balance == prev_balance
      assert transaction.new_account_balance == new_balance
      assert transaction.amount == amount
      
      assert transaction.operation_id == operation.id
    end

    test "create_transfer_sent/4 with invalid data creates a transaction" do
      operation_fixture()
      attrs = %{amount: nil, prev_account_balance: nil, new_account_balance: nil}
      agency = agency_fixture(@agency_attrs)
      {:ok, operation} = Operations.get_operation_by_code(1) 

      user_source = user_fixture(@user_source)
      source_account = account_fixture(user_source, agency)

      user_target = user_fixture(@user_target)
      target_account = account_fixture(user_target, agency)

      assert {:error, %Ecto.Changeset{}} = Transactions.create_transfer_sent(attrs, operation, source_account, target_account)
    end

    test "create_transfer_received/3 with valid data creates a transaction" do
      operation_fixture()
      
      amount = 100.0
      prev_balance = 0
      new_balance = 100.0

      attrs = %{amount: amount, prev_account_balance: prev_balance, new_account_balance: amount}
      agency = agency_fixture(@agency_attrs)
      {:ok, operation} = Operations.get_operation_by_code(2) 

      user_target = user_fixture(@user_target)
      target_account = account_fixture(user_target, agency)

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transfer_received(attrs, operation, target_account)

      assert transaction.account_id == target_account.id

      assert transaction.prev_account_balance == prev_balance
      assert transaction.new_account_balance == new_balance
      assert transaction.amount == amount
      
      assert transaction.operation_id == operation.id
    end

    test "create_transfer_received/3 with invalid data creates a transaction" do
      operation_fixture()
      attrs = %{amount: nil, prev_account_balance: nil, new_account_balance: nil}
      agency = agency_fixture(@agency_attrs)
      {:ok, operation} = Operations.get_operation_by_code(2) 

      user_target = user_fixture(@user_target)
      target_account = account_fixture(user_target, agency)

      assert {:error, %Ecto.Changeset{}} = Transactions.create_transfer_received(attrs, operation, target_account)
    end

    test "create_transfer/3 with valid data creates a transaction" do
      operation_fixture()
      
      {:ok, operation_source} = Operations.get_operation_by_code(1)
      {:ok, operation_target} = Operations.get_operation_by_code(2)
      
      agency = agency_fixture(@agency_attrs)
      amount = 100.0

      user_source = user_fixture(@user_source)
      source_account = account_fixture(user_source, agency)

      user_target = user_fixture(@user_target)
      target_account = account_fixture(user_target, agency)

      assert {:ok, %Transaction{} = source_transaction, %Transaction{} = target_transaction} = Transactions.create_transfer(source_account, target_account, amount)
      
      source_account_after = Accounts.get_account!(source_account.id)  
      target_account_after = Accounts.get_account!(target_account.id)  

      assert source_account_after.balance == source_account.balance - amount
      assert target_account_after.balance == source_account.balance + amount

      assert source_transaction.operation_id == operation_source.id
      assert source_transaction.account_id == source_account.id
      assert source_transaction.target_account_id == target_account.id
      assert source_transaction.amount == -amount
      assert source_transaction.prev_account_balance == source_account.balance
      assert source_transaction.new_account_balance == source_account.balance - amount

      assert target_transaction.operation_id == operation_target.id
      assert target_transaction.account_id == target_account.id
      assert target_transaction.amount == amount
      assert target_transaction.prev_account_balance == target_account.balance
      assert target_transaction.new_account_balance == target_account.balance + amount
    end
  end
end

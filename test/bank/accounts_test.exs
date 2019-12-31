defmodule Bank.AccountsTest do
  use Bank.DataCase

  alias Bank.Accounts

  describe "accounts" do
    alias Bank.Accounts.Account

    def account_fixture() do
      user = user_fixture()
      agency = agency_fixture()

      {:ok, account} = Accounts.create_account(user, agency)          

      account
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      account_get = Accounts.get_account!(account.id)
      
      assert account_get.id == account.id
      assert account_get.code == account.code
      assert account_get.digit == account.digit
      assert account_get.balance == account.balance

      assert Accounts.get_account!(account.id) |> Map.get(:user) |> Map.get(:name) == account.user.name
      assert Accounts.get_account!(account.id) |> Map.get(:user) |> Map.get(:email) == account.user.email
      
      assert Accounts.get_account!(account.id) |> Map.get(:agency) |> Map.get(:code) == account.agency.code
      assert Accounts.get_account!(account.id) |> Map.get(:agency) |> Map.get(:digit) == account.agency.digit
    end

    test "create_account/2 with valid data creates a account" do
      user = user_fixture()
      agency = agency_fixture()

      assert {:ok, %Account{} = account} = Accounts.create_account(user, agency)
    end

    '
    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
    '

    test "generate_account_code/1 returns the account code" do
      assert Accounts.generate_account_code(123) =~ "123"
    end

  end
end

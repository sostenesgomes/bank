defmodule Bank.AccountsTest do
  use Bank.DataCase

  alias Bank.Accounts

  describe "accounts" do
    alias Bank.Accounts.Account

    def account_fixture() do
      user = user_fixture(user_valid_attrs())
      agency = agency_fixture(agency_valid_attrs())

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

    test "create_account/2" do
      user = user_fixture(user_valid_attrs())
      agency = agency_fixture(agency_valid_attrs())

      assert {:ok, %Account{} = account} = Accounts.create_account(user, agency)
    end
    
    test "update_balance/2 with valid balance" do
      account = account_fixture()
      new_balance = 100.0

      assert {:ok, %Account{} = account} = Accounts.update_balance(account, %{balance: new_balance})
      
      account_changed = Accounts.get_account!(account.id)

      assert account_changed.balance == new_balance
    end
    
    test "update_balance/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_balance(account, %{balance: nil})
      
      account_pos = Accounts.get_account!(account.id)
      assert account_pos.balance == account.balance
    end
    
    test "generate_account_code/1 returns the account code" do
      assert Accounts.generate_account_code(123) =~ "123"
    end

  end
end

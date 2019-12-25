defmodule Bank.AccountsTest do
  use Bank.DataCase

  alias Bank.Accounts

  describe "accounts" do
    alias Bank.Accounts.Account

    @valid_attrs %{code: 985698, digit: 1, balance: 0}
    @update_attrs %{}
    @invalid_attrs %{code: nil, digit: nil, agency_id: nil, user_id: nil, balance: nil}

    def account_fixture(attrs \\ %{}) do
      user = user_fixture()
      agency = agency_fixture()

      account_params =
        attrs
        |> Enum.into(@valid_attrs)

      {:ok, account} = Accounts.create_account(user, agency, account_params)          

      account
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/3 with valid data creates a account" do
      user = user_fixture()
      agency = agency_fixture()

      assert {:ok, %Account{} = account} = Accounts.create_account(user, agency, @valid_attrs)
    end

    test "create_account/3 with invalid data returns error changeset" do
      user = nil
      agency = nil
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(user, agency, @invalid_attrs)
    end

    """
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
    """
  end
end

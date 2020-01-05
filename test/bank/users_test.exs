defmodule Bank.UsersTest do
  use Bank.DataCase

  alias Bank.{Users, Accounts}

  describe "users" do
    alias Bank.Users.User
    alias Bank.Accounts.Account

    @active_account_receive_cash_on_register %{code: "account_receive_cash_on_register", amount: 1000.0, is_active: true}
    @inactive_account_receive_cash_on_register %{code: "account_receive_cash_on_register", amount: 1000.0, is_active: false}

    test "get_user!/1 returns the user with given id" do
      user_create = user_fixture(user_valid_attrs())
      user_get = Users.get_user!(user_create.id)
      
      assert user_create.id == user_get.id
      assert user_create.name == user_get.name
      assert user_create.email == user_get.email
      
      refute user_get.password_hash == nil
    end
    
    test "get_user_by_email/1 returns the user with given email" do
      user_create = user_fixture(user_valid_attrs())
      {:ok, user_get} = Users.get_user_by_email(user_create.email)
      
      assert user_create.id == user_get.id
      assert user_create.name == user_get.name
      assert user_create.email == user_get.email
      
      refute user_get.password_hash == nil
    end
    
    test "create_user/1 with valid data creates a user" do
      attrs = user_valid_attrs()
      assert {:ok, %User{} = user} = Users.create_user(attrs)
    end
    
    test "create_user_account/1 with valid data creates a user with his account" do
      attrs = user_valid_attrs()
      agency = agency_fixture(agency_valid_attrs())

      assert {:ok, %User{} = user, %Account{} = account} = Users.create_user_account(agency, attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      attrs = user_invalid_attrs()
      assert {:error, %Ecto.Changeset{}} = Users.create_user(attrs)
    end

    test "create_user/1 with invalid name length" do
      attrs = Map.put(user_valid_attrs(), :name, "a")
      changeset = User.changeset(%User{}, attrs)
      refute changeset.valid?
      assert %{name: ["should be at least 2 character(s)"]} = errors_on(changeset)
    end

    test "create_user/1 with invalid password length" do
      attrs = Map.put(user_valid_attrs(), :password, "1234567")
      changeset = User.changeset(%User{}, attrs)
      refute changeset.valid?
      assert %{password: ["should be 6 character(s)"]} = errors_on(changeset)
    end
    
    test "create_user/1 with invalid email format" do
      attrs = Map.put(user_valid_attrs(), :email, "invalidemail.com")
      changeset = User.changeset(%User{}, attrs)
      refute changeset.valid?
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end
    
    test "create_user/1 with duplicate email" do
      user_fixture(user_valid_attrs())
      
      changeset = User.changeset(%User{}, user_valid_attrs())

      {:error, changeset} = Repo.insert(changeset)
      
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "create_user_account/1 with active account_receive_cash_on_register promotion" do
      operation_fixture()
      {:ok, promotion} = promotion_fixture(@active_account_receive_cash_on_register)

      attrs = user_valid_attrs()
      agency = agency_fixture(agency_valid_attrs())

      assert {:ok, %User{} = user, %Account{} = account} = Users.create_user_account(agency, attrs)
      
      account_after = Accounts.get_account!(account.id)

      assert account_after.balance == promotion.amount
    end

    test "create_user_account/1 with inactive account_receive_cash_on_register promotion" do
      operation_fixture()
      {:ok, _promotion} = promotion_fixture(@inactive_account_receive_cash_on_register)

      attrs = user_valid_attrs()
      agency = agency_fixture(agency_valid_attrs())

      assert {:ok, %User{} = user, %Account{} = account} = Users.create_user_account(agency, attrs)
      
      account_after = Accounts.get_account!(account.id)

      assert account_after.balance == 0
    end
  end
end

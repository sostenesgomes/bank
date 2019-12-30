defmodule Bank.UsersTest do
  use Bank.DataCase

  alias Bank.Users

  describe "users" do
    alias Bank.Users.User
    alias Bank.Accounts.Account

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      attrs = user_valid_attrs()
      assert {:ok, %User{} = user} = Users.create_user(attrs)
    end
    
    test "create_user_account/1 with valid data creates a user with his account" do
      attrs = user_valid_attrs()
      agency = agency_fixture()

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
    
    test "create_user/1 with invalid email formaat" do
      attrs = Map.put(user_valid_attrs(), :email, "invalidemail.com")
      changeset = User.changeset(%User{}, attrs)
      refute changeset.valid?
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end
  end
end

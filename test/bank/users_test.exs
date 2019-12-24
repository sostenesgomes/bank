defmodule Bank.UsersTest do
  use Bank.DataCase

  alias Bank.Users

  describe "users" do
    alias Bank.Users.User

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      attrs = user_valid_attrs()
      assert {:ok, %User{} = user} = Users.create_user(attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      attrs = user_invalid_attrs()
      assert {:error, %Ecto.Changeset{}} = Users.create_user(attrs)
    end
  end
end

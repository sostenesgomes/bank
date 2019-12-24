defmodule Bank.UsersTest do
  use Bank.DataCase

  alias Bank.Users

  describe "users" do
    alias Bank.Users.User

    @valid_attrs %{name: "User Test", email: "usertest@usertest.com", password: "passwd"}
    @invalid_attrs %{name: nil, email: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end
  end
end

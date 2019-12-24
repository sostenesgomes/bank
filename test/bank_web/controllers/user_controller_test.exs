defmodule BankWeb.UserControllerTest do
  use BankWeb.ConnCase

  alias Bank.Users
  alias Bank.Users.User

  @create_attrs %{name: "User Test", email: "usertest@usertest.com", password: "passwd"}

  @invalid_attrs %{name: nil, email: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      response = json_response(conn, 201)
      assert "User Test" == Map.get(response, "name")
      assert "usertest@usertest.com" == Map.get(response, "email")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
  
end

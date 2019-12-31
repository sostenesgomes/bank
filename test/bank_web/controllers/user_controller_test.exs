defmodule BankWeb.UserControllerTest do
  use BankWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      agency_fixture()
      conn = post(conn, Routes.user_path(conn, :create), user: user_valid_attrs())
      response = json_response(conn, 201)
      assert "User Test" == Map.get(response, "name")
      assert "usertest@usertest.com" == Map.get(response, "email")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      agency_fixture()
      conn = post(conn, Routes.user_path(conn, :create), user: user_invalid_attrs())
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login" do
    
    test "when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, Routes.user_path(conn, :login), email: user.email, password: user.password)
      response = json_response(conn, 200)
      
      assert user.name == Map.get(response, "name")
      assert user.email == Map.get(response, "email")
      assert is_bitstring(Map.get(response, "token"))
    end

    test "renders unauthorized when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, Routes.user_path(conn, :login), email: user.email, password: "wrong pass")
      
      assert json_response(conn, 401) == "Unauthorized"
    end
  end
  
end

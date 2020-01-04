defmodule BankWeb.TransactionControllerTest do
  use BankWeb.ConnCase

  alias Bank.{Accounts, Users, Agencies, Transactions}
  alias Bank.Transactions.Transaction
  alias Bank.Accounts.Account
  alias Bank.Auth.Guardian

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  @user_target %{name: "User Target", email: "user_target@usertest.com", password: "passwd"}      
  
  @agency_target %{name: "Agency Target", code: 17815, digit: 1}
  
  def fixture(:transaction) do
    {:ok, transaction} = Transactions.create_transaction(@create_attrs)
    transaction
  end

  def authenticate(conn) do
    user = user_fixture(user_valid_attrs())
    agency = agency_fixture(agency_valid_attrs())

    {:ok, %Account{} = account} = Accounts.create_account(user, agency)
    
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{jwt}")
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> authenticate()

    {:ok, conn: conn}
  end

  #describe "create transaction" do
  #  test "renders transaction when data is valid", %{conn: conn} do
  #    conn = post(conn, Routes.transaction_path(conn, :create), transaction: @create_attrs)
  #    assert %{"id" => id} = json_response(conn, 201)["data"]#

  #    conn = get(conn, Routes.transaction_path(conn, :show, id))

  #    assert %{
  #             "id" => id
  #           } = json_response(conn, 200)["data"]
  #  end

  #  test "renders errors when data is invalid", %{conn: conn} do
  #    conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
  #    assert json_response(conn, 422)["errors"] != %{}
  #  end
  #end
    
  describe "create transfer" do
    '
    test "renders transaction when data is valid", %{conn: conn} do
      operation_fixture()

      user_target = user_fixture(@user_target)
      agency_target = agency_fixture(@agency_target)
      target_account = account_fixture(user_target, agency_target)

      transfer = %{target_account_code: target_account.code, target_account_digit: target_account.digit, amount: 100.00}
      
      conn = post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)
      assert %{"id" => 1} = json_response(conn, 201)
    end
    '
  #  test "renders errors when data is invalid", %{conn: conn} do
  #    conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
  #    assert json_response(conn, 422)["errors"] != %{}
  #  end
  end

end

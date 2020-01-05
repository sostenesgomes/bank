defmodule BankWeb.TransactionControllerTest do
  use BankWeb.ConnCase

  alias Bank.{Accounts, Users}
  alias Bank.Accounts.Account
  alias Bank.Auth.Guardian

  @transfer_invalid_attrs %{target_account_code: nil, target_account_digit: nil, amount: nil}
  @cashout_invalid_attrs %{amount: nil}

  @user_target %{name: "User Target", email: "user_target@usertest.com", password: "passwd"}      
  
  @agency_target %{name: "Agency Target", code: 17815, digit: 1}
  
  def authenticate(conn) do
    user = user_fixture(user_valid_attrs())
    agency = agency_fixture(agency_valid_attrs())

    {:ok, %Account{} = _} = Accounts.create_account(user, agency)
    
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
    
  describe "create transfer" do
    test "renders transaction when data is valid", %{conn: conn} do
      
      operation_fixture()
      amount = 100.0

      user_attrs = user_valid_attrs()
      {:ok, user_source} = Users.get_user_by_email(user_attrs.email)
      source_account = user_source.account
      
      user_target = user_fixture(@user_target)
      agency_target = agency_fixture(@agency_target)
      target_account = account_fixture(user_target, agency_target)

      transfer = %{target_account_code: target_account.code, target_account_digit: target_account.digit, amount: amount}

      conn = post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)
      response = json_response(conn, 201)

      assert -amount == Map.get(response, "from") |> Map.get("amount")
      assert amount == Map.get(response, "to") |> Map.get("amount")

      assert "#{source_account.code}-#{source_account.digit}" == Map.get(response, "from") |> Map.get("account")
      assert "#{target_account.code}-#{target_account.digit}" == Map.get(response, "to") |> Map.get("account")

      source_account_after = Accounts.get_account!(source_account.id)  
      target_account_after = Accounts.get_account!(target_account.id)  

      assert source_account_after.balance == source_account.balance - amount
      assert target_account_after.balance == source_account.balance + amount
    end

    test "renders errors when account not exists", %{conn: conn} do
      operation_fixture()
      amount = 100.0

      transfer = %{target_account_code: "000000", target_account_digit: 0, amount: amount}
      conn = post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)

      assert json_response(conn, 404) == "Account not found"
    end
    
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :transfer), transfer: @transfer_invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when amount equal 0", %{conn: conn} do
      user_target = user_fixture(@user_target)
      agency_target = agency_fixture(@agency_target)
      target_account = account_fixture(user_target, agency_target)
      transfer = %{target_account_code: target_account.code, target_account_digit: target_account.digit, amount: 0}
      conn = post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)
      assert ["must be greater than 0"] = json_response(conn, 422)["errors"]["amount"]
    end
    
  end

  describe "create cashout" do
    test "renders transaction when data is valid", %{conn: conn} do
      
      operation_fixture()
      amount = 100.0

      user_attrs = user_valid_attrs()
      {:ok, user_source} = Users.get_user_by_email(user_attrs.email)
      source_account = user_source.account
      
      cashout = %{amount: amount}

      conn = post(conn, Routes.transaction_path(conn, :cashout), cashout: cashout)
      response = json_response(conn, 201)

      assert -amount == Map.get(response, "amount")

      source_account_after = Accounts.get_account!(source_account.id)  

      assert source_account_after.balance == source_account.balance - amount
    end
    
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :cashout), cashout: @cashout_invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
    
    test "renders errors when amount equal 0", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :cashout), cashout: %{amount: 0})
      assert ["must be greater than 0"] = json_response(conn, 422)["errors"]["amount"]
    end
    
  end


end

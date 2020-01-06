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
      account = user_source.account
      {:ok, source_account} = Accounts.update_balance(account, %{balance: amount})
      
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
      assert target_account_after.balance == target_account.balance + amount
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

    test "renders errors when balance is insuficient", %{conn: conn} do
      operation_fixture()
      amount = 100.0
            
      user_target = user_fixture(@user_target)
      agency_target = agency_fixture(@agency_target)
      target_account = account_fixture(user_target, agency_target)

      transfer = %{target_account_code: target_account.code, target_account_digit: target_account.digit, amount: amount}
      
      conn = post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)
      
      assert ["must be greater than or equal to 0"] = json_response(conn, 422)["errors"]["balance"]
    end
    
  end

  describe "create cashout" do
    test "renders transaction when data is valid", %{conn: conn} do
      
      operation_fixture()
      amount = 100.0

      user_attrs = user_valid_attrs()
      {:ok, user_source} = Users.get_user_by_email(user_attrs.email)
      
      account = user_source.account
      {:ok, source_account} = Accounts.update_balance(account, %{balance: amount})
      
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

    test "renders balance errors on source_account when balance is unsuficient", %{conn: conn} do
      operation_fixture()
      amount = 100.0

      cashout = %{amount: amount}

      conn = post(conn, Routes.transaction_path(conn, :cashout), cashout: cashout)
      assert ["must be greater than or equal to 0"] = json_response(conn, 422)["errors"]["balance"]
    end
    
  end

  describe "email" do
    test "test checkout_email with given user and amount" do
      user = %{name: "Customer Test", email: "customermailtest@bank.com"}  
      amount_format = "R$ 500,00"
      
      assert %Bamboo.Email{} = email = BankWeb.Email.cashout_email(user, amount_format)
      
      assert email.to == user.email
      assert email.assigns == %{}
      assert email.attachments == []
      assert email.bcc == nil
      assert email.cc == nil
      assert email.from == "support@bank.com"
      assert email.headers == %{}
      assert email.private == %{}
      assert email.subject == "Cashout Performed"
      assert email.html_body == "<p>Hi, #{user.name}. <br><br> Your cash out has been successfully completed. <br> Amount: #{amount_format}</p>"
      assert email.text_body == "Hi, #{user.name}. Your cash out has been successfully completed. Amount: #{amount_format}"
    end
  end

  describe "report" do
    test "test report total", %{conn: conn} do
      operation_fixture()
      amount = 100.0

      user_attrs = user_valid_attrs()
      {:ok, user_source} = Users.get_user_by_email(user_attrs.email)
      account = user_source.account
      {:ok, _source_account} = Accounts.update_balance(account, %{balance: amount})
      
      user_target = user_fixture(@user_target)
      agency_target = agency_fixture(@agency_target)
      target_account = account_fixture(user_target, agency_target)

      transfer = %{target_account_code: target_account.code, target_account_digit: target_account.digit, amount: amount}
      post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)

      conn = get(conn, Routes.transaction_path(conn, :report), type: "total", reference: nil)
      response = json_response(conn, 200)

      assert "R$ 100,00" == Map.get(response, "total_cash_inflow")
      assert "R$ -100,00" == Map.get(response, "total_cash_outflow")
    end

    test "test report by day", %{conn: conn} do
      operation_fixture()
      amount = 100.0

      user_attrs = user_valid_attrs()
      {:ok, user_source} = Users.get_user_by_email(user_attrs.email)
      account = user_source.account
      {:ok, _source_account} = Accounts.update_balance(account, %{balance: amount})
      
      user_target = user_fixture(@user_target)
      agency_target = agency_fixture(@agency_target)
      target_account = account_fixture(user_target, agency_target)

      transfer = %{target_account_code: target_account.code, target_account_digit: target_account.digit, amount: amount}
      post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)

      today = Date.utc_today
      day = 
        [today.year, today.month, today.day]
          |> Enum.map(&to_string/1)
          |> Enum.map(&String.pad_leading(&1, 2, "0"))
          |> Enum.join("-")
          
      conn = get(conn, Routes.transaction_path(conn, :report), type: "day", reference: day)
      response = json_response(conn, 200)

      assert "R$ 100,00" == Map.get(response, "total_cash_inflow")
      assert "R$ -100,00" == Map.get(response, "total_cash_outflow")
    end

    test "test report by month", %{conn: conn} do
      operation_fixture()
      amount = 100.0

      user_attrs = user_valid_attrs()
      {:ok, user_source} = Users.get_user_by_email(user_attrs.email)
      account = user_source.account
      {:ok, _source_account} = Accounts.update_balance(account, %{balance: amount})
      
      user_target = user_fixture(@user_target)
      agency_target = agency_fixture(@agency_target)
      target_account = account_fixture(user_target, agency_target)

      transfer = %{target_account_code: target_account.code, target_account_digit: target_account.digit, amount: amount}
      post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)

      today = Date.utc_today
      month = 
        [today.year, today.month]
          |> Enum.map(&to_string/1)
          |> Enum.map(&String.pad_leading(&1, 2, "0"))
          |> Enum.join("-")
          
      conn = get(conn, Routes.transaction_path(conn, :report), type: "month", reference: month)
      response = json_response(conn, 200)

      assert "R$ 100,00" == Map.get(response, "total_cash_inflow")
      assert "R$ -100,00" == Map.get(response, "total_cash_outflow")
    end

    test "test report by year", %{conn: conn} do
      operation_fixture()
      amount = 100.0

      user_attrs = user_valid_attrs()
      {:ok, user_source} = Users.get_user_by_email(user_attrs.email)
      account = user_source.account
      {:ok, _source_account} = Accounts.update_balance(account, %{balance: amount})
      
      user_target = user_fixture(@user_target)
      agency_target = agency_fixture(@agency_target)
      target_account = account_fixture(user_target, agency_target)

      transfer = %{target_account_code: target_account.code, target_account_digit: target_account.digit, amount: amount}
      post(conn, Routes.transaction_path(conn, :transfer), transfer: transfer)

      today = Date.utc_today
      year = to_string(today.year)
          
      conn = get(conn, Routes.transaction_path(conn, :report), type: "year", reference: year)
      response = json_response(conn, 200)

      assert "R$ 100,00" == Map.get(response, "total_cash_inflow")
      assert "R$ -100,00" == Map.get(response, "total_cash_outflow")
    end
  end
end

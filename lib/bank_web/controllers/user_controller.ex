defmodule BankWeb.UserController do
  use BankWeb, :controller

  alias Bank.Users
  alias Bank.Users.User
  alias Bank.Agencies
  alias Bank.Accounts.Account
  alias Bank.Auth.Guardian

  action_fallback BankWeb.FallbackController

  @doc """
  Perform create user and render response

  """
  def create(conn, %{"user" => user_params}) do
    agency = Agencies.get_agency_by_code_dg!(1234, 0) # In the future, we can change this. Default agency choosed.

    with {:ok, %User{} = user, %Account{} = account} <- Users.create_user_account(agency, user_params) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, account: account})
    end
  end

  @doc """
  Perform user login and render response

  """
  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:ok)
      |> render("user_authenticated.json", %{user: user, token: token})
    end
  end

end

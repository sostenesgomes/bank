defmodule BankWeb.UserController do
  use BankWeb, :controller

  alias Bank.Users
  alias Bank.Users.User

  alias Bank.Agencies

  action_fallback BankWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    agency = Agencies.get_agency_by_code_dg!(1234, 0)

    with {:ok, %User{} = user} <- Users.create_user_account(agency, user_params) do
      conn
      |> put_status(:created)
      |> render("user.json", user: user)
    end
  end

end

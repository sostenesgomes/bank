defmodule BankWeb.UserController do
  use BankWeb, :controller

  alias Bank.Users
  alias Bank.Users.User

  action_fallback BankWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("user.json", user: user)
    end
  end

end

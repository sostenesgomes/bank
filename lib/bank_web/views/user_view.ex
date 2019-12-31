defmodule BankWeb.UserView do
  use BankWeb, :view
  alias BankWeb.UserView

  def render("user.json", %{user: user, account: account}) do
    %{
      name: user.name,
      email: user.email,
      account: %{
        code: account.code,
        digit: account.digit,
        agency: %{
          code: account.agency.code,
          digit: account.agency.digit
        }
      }
    }
  end

  def render("user_authenticated.json", %{user: user, token: token}) do
    %{
      name: user.name,
      email: user.email,
      token: token,
    }
  end
end

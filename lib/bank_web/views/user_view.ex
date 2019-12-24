defmodule BankWeb.UserView do
  use BankWeb, :view
  alias BankWeb.UserView

  def render("user.json", %{user: user}) do
    %{
      name: user.name,
      email: user.email
    }
  end
end

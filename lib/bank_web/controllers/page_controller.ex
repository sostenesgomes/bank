defmodule BankWeb.PageController do
  use BankWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, _params) do
    json(conn, %{id: 15})
  end
end

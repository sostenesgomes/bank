defmodule BankWeb.TransactionView do
  use BankWeb, :view
  alias BankWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id}
  end

  def render("transfer.json", %{data: data}) do
    %{id: data.id}
  end
end

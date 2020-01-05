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

  def render("transfer.json", %{source_transaction: source_transaction, target_transaction: target_transaction}) do
    %{
      from: %{
        account: "#{source_transaction.source_account.code}-#{source_transaction.source_account.digit}",
        amount: source_transaction.amount
      },
      to: %{
        account: "#{target_transaction.source_account.code}-#{target_transaction.source_account.digit}",
        amount: target_transaction.amount
      } 
    }
  end

  def render("cashout.json", %{cashout_transaction: cashout_transaction}) do
    %{amount: cashout_transaction.amount}
  end

  def render("account_not_found.json", %{account_not_found: account_not_found_message}) do
    account_not_found_message
  end

  def render("report.json", %{total_added: total_added, total_removed: total_removed}) do
    %{
      total_added: total_added,
      total_removed: total_removed
    }
  end

end

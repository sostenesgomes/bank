# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bank.Repo.insert!(%Bank.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Seeds for Agencies
alias Bank.Repo
alias Bank.Agencies.Agency
alias Bank.Operations.Operation
alias Bank.Promotions.Promotion

Repo.insert!(%Agency{name: "Agency One", code: 1234, digit: 0}, on_conflict: :nothing)

# Seeds for Operations
Repo.insert!(%Operation{code: 1, title: "Transfer Sent"}, on_conflict: :nothing)
Repo.insert!(%Operation{code: 2, title: "Transfer Received"}, on_conflict: :nothing)
Repo.insert!(%Operation{code: 3, title: "Cashout"}, on_conflict: :nothing)

# Seeds for Promotions
Repo.insert!(%Promotion{code: "account_receive_cash_on_register", amount: 1000.0, is_active: true}, on_conflict: :nothing)

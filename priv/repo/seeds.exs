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

Repo.insert!(%Bank.Agencies.Agency{name: "Agency One", code: 1234, digit: 0}, on_conflict: :nothing)
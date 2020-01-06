defmodule Bank.TestHelpers do

  alias Bank.{Repo, Users, Agencies, Accounts}
  alias Bank.Operations.Operation
  alias Bank.Promotions.Promotion

  @doc false
  def user_valid_attrs() do
    %{name: "User Test", email: "usertest@usertest.com", password: "passwd"}      
  end
  
  @doc false
  def user_invalid_attrs() do
    %{name: nil, email: nil, password: nil}
  end

  @doc false
  def agency_valid_attrs() do
    %{name: "Agency One", code: 1234, digit: 0}
  end
  
  @doc false
  def agency_invalid_attrs() do
    %{name: nil, email: nil, password: nil}
  end

  @doc """
  A helper that create an User
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(attrs)
      |> Users.create_user()

    user
  end
  
  @doc """
  A helper that create an Agency
  """
  def agency_fixture(attrs \\ %{}) do
    {:ok, agency} =
      attrs
      |> Enum.into(attrs)
      |> Agencies.create_agency()

    agency
  end

  @doc """
  A helper that create an Account
  """
  def account_fixture(user, agency) do
    {:ok, account} = Accounts.create_account(user, agency)

    account
  end

  @doc """
  A helper that create operations
  """
  def operation_fixture() do
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)

    operations = [
      %{code: 1, title: "Transfer Sent", inserted_at: now, updated_at: now},
      %{code: 2, title: "Transfer Received", inserted_at: now, updated_at: now},
      %{code: 3, title: "Cashout", inserted_at: now, updated_at: now}
    ]

    Repo.insert_all(Operation, operations, on_conflict: :nothing)
  end

  @doc """
  A helper that create a promotion
  """
  def promotion_fixture(attrs \\ %{}) do
    promotion = 
      %Promotion{}
      |> Promotion.changeset(attrs)
      |> Repo.insert()

    promotion  
  end

end
  
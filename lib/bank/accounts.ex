defmodule Bank.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

  alias Bank.Accounts.Account
  alias Bank.Users.User
  alias Bank.Agencies.Agency

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id) do 
    account = 
      Repo.get!(Account, id) 
      |> Repo.preload(:user) 
      |> Repo.preload(:agency)

    account
  end
  
  @doc """
  Gets a single Account by code and digit.

  ## Examples

      iex> get_account_by_code_dg(1234, 1)
      {:ok, %User{}}

      iex> get_account_by_code_dg(0000, 5)
      {:error, :not_found}
  """
  def get_account_by_code_dg(code, digit) do 
    Repo.get_by(Account, code: code, digit: digit) 
    |> case do 
        nil ->
          {:error, :not_found}
        account ->
          {:ok, account}  
      end
  end

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(user, agency)
      {:ok, %Account{}}

      iex> create_account(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(%User{} = user, %Agency{} = agency) do
    attrs = %{code: generate_account_code(user.id), digit: 1, balance: 0}
    
    %Account{}
    |> Account.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:agency, agency)
    |> Repo.insert()
  end

  @doc """
  Updates account balance.

  ## Examples

      iex> update_balance(account, %{balance: balance})
      {:ok, %Account{}}

      iex> update_balance(account, %{balance: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_balance(%Account{} = account, %{balance: balance} = new_balance) do
    account
    |> Account.changeset(new_balance)
    |> Repo.update()
  end

  @doc """
  Returns and String containing a code to account

    iex> generate_account_code(account)
    %Ecto.Changeset{source: %Account{}}

  """
  def generate_account_code(user_id) do
    if user_id > 0 do
      time = Time.utc_now
      "#{time.second}#{user_id}#{time.minute}"
    end
  end

end

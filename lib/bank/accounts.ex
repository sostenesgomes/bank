defmodule Bank.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Ecto.UUID
  alias Bank.Repo

  alias Bank.Accounts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

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
  Creates a account.

  ## Examples

      iex> create_account(user, agency)
      {:ok, %Account{}}

      iex> create_account(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(user, agency) do
    attrs = %{code: generate_account_code(user.id), digit: 1, balance: 0}
    
    %Account{}
    |> Account.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:agency, agency)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
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

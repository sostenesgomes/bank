defmodule Bank.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  
  alias Ecto.Multi
  alias Bank.Repo
  alias Bank.Accounts
  alias Bank.Users.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single User by email.

  ## Examples

      iex> get_user_by_email(email@bank.com)
      {:ok, %User{}}

      iex> get_user_by_email(notfound@bank.com)
      {:error, :not_found}
  """
  def get_user_by_email(email) do 
    Repo.get_by(User, email: email) 
    |> Repo.preload(:account)
    |> case do 
        nil ->
          {:error, :not_found}
        user ->
          {:ok, user}  
      end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  def create_user_account(agency, attrs \\ %{}) do
    Multi.new()
      |> Multi.run(:user, fn _, _ ->
        create_user(attrs)
      end)  
      |> Multi.run(:account, fn _, %{user: user} ->
        Accounts.create_account(user, agency)
      end)  
      |> Repo.transaction()
      |> case do
        {:ok, %{user: user, account: account}} ->
          {:ok, user, account}
  
        {:error, _, failed_value, _} ->
          {:error, failed_value}
      end
  end 
end

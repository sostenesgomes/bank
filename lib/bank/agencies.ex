defmodule Bank.Agencies do
  @moduledoc """
  The Agencies context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

  alias Bank.Agencies.Agency

  @doc """
  Gets a single agency.

  Raises `Ecto.NoResultsError` if the Agency does not exist.

  ## Examples

      iex> get_agency!(123)
      %Agency{}

      iex> get_agency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_agency!(id), do: Repo.get!(Agency, id)

  @doc """
  Gets a single agency by code and digit.

  ## Examples

      iex> get_agency_by_code_dg!(1234, 0)
      %Agency{}

      iex> get_agency_by_code_dg!(456)
      ** (Ecto.NoResultsError)
  """
  def get_agency_by_code_dg!(code, digit), do: Repo.get_by(Agency, [code: code, digit: digit])

  @doc """
  Creates a agency.

  ## Examples

      iex> create_agency(%{field: value})
      {:ok, %Agency{}}

      iex> create_agency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_agency(attrs \\ %{}) do
    %Agency{}
    |> Agency.changeset(attrs)
    |> Repo.insert()
  end
end

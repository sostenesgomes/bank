defmodule Bank.Operations do
  @moduledoc """
  The Operations context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

  alias Bank.Operations.Operation

  @doc """
  Gets a single operation.

  Raises `Ecto.NoResultsError` if the Operation does not exist.

  ## Examples

      iex> get_operation!(123)
      %Operation{}

      iex> get_operation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_operation!(id), do: Repo.get!(Operation, id)

  @doc """
  Gets a single Operation by code.

  ## Examples

      iex> get_operation_by_code(1)
      {:ok, %User{}}

      iex> get_operation_by_code(0)
      {:error, :not_found}
  """
  def get_operation_by_code(code) do 
    Repo.get_by(Operation, code: code) 
    |> case do 
        nil ->
          {:error, :not_found}
        operation ->
          {:ok, operation}  
      end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking operation changes.

  ## Examples

      iex> change_operation(operation)
      %Ecto.Changeset{source: %Operation{}}

  """
  def change_operation(%Operation{} = operation) do
    Operation.changeset(operation, %{})
  end
end

defmodule Bank.Operations do
  @moduledoc """
  The Operations context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

  alias Bank.Operations.Operation

  @doc """
  Gets a single Operation by code.

  ## Examples

      iex> get_operation_by_code(1)
      {:ok, %Operation{}}

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
end

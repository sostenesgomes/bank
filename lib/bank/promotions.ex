defmodule Bank.Promotions do
  @moduledoc """
  The Promotions context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

  alias Bank.Promotions.Promotion

  @doc """
  Gets a single Promotion by code.

  ## Examples

    iex> get_promotion_by_code(account_receive_cash_on_register)
    {:ok, %Promotion{}}

    iex> get_promotion_by_code(not_found_promotion)
    {:error, :not_found}
  """
  def get_promotion_by_code(code) do 
    Repo.get_by(Promotion, code: code) 
    |> case do 
        nil ->
          {:error, :not_found}
        promotion ->
          {:ok, promotion}  
      end
  end
end

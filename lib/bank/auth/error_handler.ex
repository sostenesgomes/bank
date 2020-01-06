defmodule Bank.Auth.ErrorHandler do
  @moduledoc """
  The module to Handler auth erros
  """
  
  import Plug.Conn

  @doc """
    Send 401 http status error in body 
  """
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
  
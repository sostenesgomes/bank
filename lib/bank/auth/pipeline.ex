defmodule Bank.Auth.Pipeline do
  @moduledoc """
    Define a pipeline to authentication procces
  """
  
  use Guardian.Plug.Pipeline, otp_app: :api,
    module: Bank.Auth.Guardian,
    error_handler: Bank.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
 
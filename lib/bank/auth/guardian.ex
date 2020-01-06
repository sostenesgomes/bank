defmodule Bank.Auth.Guardian do
  @moduledoc """
  Guardian Module to support authentication.
  """
  use Guardian, otp_app: :bank

  alias Bank.Users

  @doc """
  Returns a subject for a given token.
  """
  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  @doc """
    Returns a resource from claims.
  """
  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Users.get_user!(id)
    {:ok, resource}
  end

  @doc """
    Authenticate user and return the user data and token created.

    ## Examples

      iex> authenticate(email, password)      
      {:ok, user, token}

      iex> authenticate(email, password)
      {:error, :unauthorized}

  """
  def authenticate(email, password) do
    with {:ok, user} <- Users.get_user_by_email(email) do
      case validate_password(password, user.password_hash) do
        true ->
          create_token(user)
        false ->
          {:error, :unauthorized}
      end
    end
  end

  @doc """
    Validate entry password with user password hash.
  """
  defp validate_password(password, password_hash) do
    Bcrypt.verify_pass(password, password_hash)
  end

  @doc """
    Sign user and return a created token to user.
  """
  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end

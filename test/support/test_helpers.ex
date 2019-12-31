defmodule Bank.TestHelpers do

  alias Bank.{Users, Agencies}
  @doc false
  def user_valid_attrs() do
    %{name: "User Test", email: "usertest@usertest.com", password: "passwd"}      
  end
  
  @doc false
  def user_invalid_attrs() do
    %{name: nil, email: nil, password: nil}
  end

  @doc false
  def agency_valid_attrs() do
    %{name: "Agency One", code: 1234, digit: 0}
  end
  
  @doc false
  def agency_invalid_attrs() do
    %{name: nil, email: nil, password: nil}
  end

  @doc """
  A helper that create an User
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(user_valid_attrs())
      |> Users.create_user()

    user
  end
  
  @doc """
  A helper that create an Agency
  """
  def agency_fixture(attrs \\ %{}) do
    {:ok, agency} =
      attrs
      |> Enum.into(agency_valid_attrs())
      |> Agencies.create_agency()

    agency
  end

end
  
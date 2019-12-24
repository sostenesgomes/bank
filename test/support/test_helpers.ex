defmodule Bank.TestHelpers do

    alias Bank.{Users, Agencies}

    def user_valid_attrs() do
      %{name: "User Test", email: "usertest@usertest.com", password: "passwd"}      
    end
    
    def user_invalid_attrs() do
      %{name: nil, email: nil, password: nil}
    end
    
    def agency_valid_attrs() do
      %{name: "Agency One", code: 1234, digit: 0}
    end
    
    def agency_invalid_attrs() do
      %{name: nil, email: nil, password: nil}
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(user_valid_attrs())
        |> Users.create_user()

      user
    end
    
    def agency_fixture(attrs \\ %{}) do
      {:ok, agency} =
        attrs
        |> Enum.into(%{name: "Agency One", code: 1234, digit: 0})
        |> Agencies.create_agency()

      agency
    end

  end
  
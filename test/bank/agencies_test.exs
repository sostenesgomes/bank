defmodule Bank.AgenciesTest do
  use Bank.DataCase

  alias Bank.Agencies

  describe "agencies" do
    alias Bank.Agencies.Agency

    test "get_agency!/1 returns the agency with given id" do
      agency = agency_fixture()
      assert Agencies.get_agency!(agency.id) == agency
    end

    test "get_agency_by_code_dg!/2 returns the agency with given code and digit" do
      agency = agency_fixture()
      assert Agencies.get_agency_by_code_dg!(agency.code, agency.digit) == agency
    end

    test "create_agency/1 with valid data creates a agency" do
      attrs = agency_valid_attrs()
      assert {:ok, %Agency{} = agency} = Agencies.create_agency(attrs)
    end

    test "create_agency/1 with invalid data returns error changeset" do
      attrs = agency_invalid_attrs()
      assert {:error, %Ecto.Changeset{}} = Agencies.create_agency(attrs)
    end

    test "change_agency/1 returns a agency changeset" do
      agency = agency_fixture()
      assert %Ecto.Changeset{} = Agencies.change_agency(agency)
    end
  end
end

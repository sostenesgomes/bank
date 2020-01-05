defmodule Bank.PromotionsTest do
  use Bank.DataCase

  alias Bank.Promotions

  describe "promotions" do
    alias Bank.Promotions.Promotion

    @active_account_receive_cash_on_register %{code: "account_receive_cash_on_register", amount: 1000.0, is_active: true}
    @inactive_account_receive_cash_on_register %{code: "account_receive_cash_on_register", amount: 1000.0, is_active: false}

    def promotion_fixture(attrs \\ %{}) do
      promotion = 
        %Promotion{}
        |> Promotion.changeset(attrs)
        |> Repo.insert()

      promotion  
    end

    test "get_promotion_by_code/1 returns active account_receive_cash_on_register with given code " do
      {:ok, promotion} = promotion_fixture(@active_account_receive_cash_on_register)
      {:ok, promotion_active} = Promotions.get_promotion_by_code(promotion.code)
                  
      assert promotion.id == promotion_active.id
      assert promotion.code == promotion_active.code
      assert promotion.amount == promotion_active.amount
      assert promotion.is_active == promotion_active.is_active
      
    end

    test "get_promotion_by_code/1 returns inactive account_receive_cash_on_register with given code " do
      {:ok, promotion} = promotion_fixture(@inactive_account_receive_cash_on_register)
      {:ok, promotion_inactive} = Promotions.get_promotion_by_code(promotion.code)
      
      assert promotion.id == promotion_inactive.id
      assert promotion.code == promotion_inactive.code
      assert promotion.amount == promotion_inactive.amount
      assert promotion.is_active == promotion_inactive.is_active
    end
  end
end

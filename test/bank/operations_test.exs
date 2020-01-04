defmodule Bank.OperationsTest do
  use Bank.DataCase

  alias Bank.Operations

  describe "operations" do
    alias Bank.Operations.Operation

    test "get_operation_by_code/1 returns the operation with given code" do
      operation_fixture()
      
      {:ok, operation_code_1} = Operations.get_operation_by_code(1)
      assert operation_code_1.code == 1
      assert operation_code_1.title == "Transfer Sent"
      
      {:ok, operation_code_2} = Operations.get_operation_by_code(2)
      assert operation_code_2.code == 2
      assert operation_code_2.title == "Transfer Received"
      
      {:ok, operation_code_3} = Operations.get_operation_by_code(3)
      assert operation_code_3.code == 3
      assert operation_code_3.title == "Cashout"
      
    end
  end  
end

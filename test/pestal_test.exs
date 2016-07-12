defmodule PestalTest do
  use ExUnit.Case
  doctest Pestal

  test "send request" do
    {:ok, resp} = Pestal.send_req
    assert resp =~ "coupon"
  end
end

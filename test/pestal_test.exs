defmodule PestalTest do
  use ExUnit.Case
  doctest Pestal

  test "send request" do
    resp = Pestal.request
    assert resp =~ ~r/MyCoupon/
  end
end

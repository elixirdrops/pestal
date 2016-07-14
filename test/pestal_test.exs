defmodule PestalTest do
  use ExUnit.Case
  doctest Pestal

  test "send request" do
    resp = Pestal.request("GET", "http://localhost:2000/", nil, [])
    assert resp =~ ~r/MyCoupon/
  end
end

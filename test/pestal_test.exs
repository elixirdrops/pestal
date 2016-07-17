defmodule PestalTest do
  use ExUnit.Case
  doctest Pestal

  test "send request" do
    {:ok, client} = Pestal.start("http://localhost:2000", [])
    resp = Pestal.request(client, "GET", "/", nil, [])
    IO.inspect(resp)
    # assert resp =~ ~r/MyCoupon/
    # assert resp =~ ~r/Copyright/
  end
end

defmodule IntercomTest do
  use ExUnit.Case
  doctest Intercom

  test "greets the world" do
    assert Intercom.hello() == :world
  end
end

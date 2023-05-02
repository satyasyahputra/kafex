defmodule KafexTest do
  use ExUnit.Case
  doctest Kafex

  test "greets the world" do
    assert Kafex.hello() == :world
  end
end

defmodule VerbalexTest do
  use ExUnit.Case
  doctest Verbalex

  test "greets the world" do
    assert Verbalex.hello() == :world
  end
end

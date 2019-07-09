defmodule VerbalexTest do
  @moduledoc """
  Test coverage is mostly doctests right now.
  Pull requests to add more are always welcome!
  """
  use ExUnit.Case
  doctest Verbalex

  alias Verbalex, as: Vlx

  test "can compose the expected regex string from required functions" do
    assert "^(?:foo)(bar)*" ==
             ""
             |> Vlx.start_of_line()
             |> Vlx.find("foo")
             |> Vlx.capture("bar")
             |> Vlx.zero_or_more()

    assert "(?<protocols>(?:http)s?(?::\/\/))" ==
             ""
             |> Vlx.find("http")
             |> Vlx.maybe("s")
             |> Vlx.then("://")
             |> Vlx.capture_as("protocols")
  end
end

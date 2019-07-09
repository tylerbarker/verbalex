# Verbalex

[![Hex pm](http://img.shields.io/hexpm/v/verbalex.svg?style=flat)](https://hex.pm/packages/verbalex)

Verbalex is a library for creating complex regular expressions with the reader & writer in mind.
It does not aim to replace Elixir's already excellent [Regex](https://hexdocs.pm/elixir/Regex.html) module for operating on regex. Instead, it focuses only on building the `~r/regexes/` themselves.

```elixir
alias Verbalex, as: Vlx

protocols = ""
  |> Vlx.find("http")
  |> Vlx.maybe("s")
  |> Vlx.then("://")
  |> Vlx.capture_as("protocols")
  |> Regex.compile!()

# ~r/(?<protocols>(?:http)s?(?::\/\/))/

Regex.named_captures(protocols, "https://github.com/tylerbarker")
# %{"protocols" => "https://"}
```

## Installation

```elixir
def deps do
  [
    {:verbalex, "~> 0.1.0-dev"}
  ]
end
```

## Docs

Documentation can be found at [https://hexdocs.pm/verbalex](https://hexdocs.pm/verbalex).

## Acknowledgements

Verbalex is essentially an Elixir port of the popular [Verbal Expressions](https://github.com/VerbalExpressions) family of libraries, while also taking some inspiration from [Simple Regex](https://simple-regex.com/).

Thanks to Max Szengal for laying down some of the groundwork in 2013 with [ElixirVerbalExpressions](https://github.com/VerbalExpressions/ElixirVerbalExpressions).

## Contributing

For issues, comments or feedback please first [create an issue](https://github.com/tylerbarker/verbalex/issues).

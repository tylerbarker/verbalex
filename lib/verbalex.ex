defmodule Verbalex do
  @moduledoc """
  Documentation for Verbalex.
  """

  defguardp are_binaries(x, y) when is_binary(x) and is_binary(y)
  defguardp are_integers(x, y) when is_integer(x) and is_integer(y)

  ### Anchors ###

  @doc ~S"""
  Express the start of a line regex anchor. Translates to '^'.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.start_of_line() |> Vlx.find("A long time ago...") |> Regex.compile!()
      ~r/^(?:A\ long\ time\ ago\.\.\.)/
  """
  @spec start_of_line(binary()) :: binary()
  def start_of_line(before \\ "") when is_binary(before), do: before <> "^"

  @doc ~S"""
  Express the end of a line regex anchor. Translates to '$'.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.find("far, far, away.") |> Vlx.end_of_line() |> Regex.compile!()
      ~r/(?:far,\ far,\ away\.)$/
  """
  @spec end_of_line(binary()) :: binary()
  def end_of_line(before \\ "") when is_binary(before), do: before <> "$"

  @doc ~S"""
  Express a string literal to be matched exactly and wraps in a non-capturing group. Escapes special characters by default.
  Turn off character escapes with the `escape: false` option.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.find("www.") |> Vlx.then("example.com")
      "(?:www\\.)(?:example\\.com)"
  """
  @spec then(binary(), binary(), [{:escape, false}]) :: binary()
  def then(before, string, opts \\ [])

  def then(before, string, escape: false) when are_binaries(before, string),
    do: before <> "(?:" <> string <> ")"

  def then(before, string, _) when are_binaries(before, string),
    do: before <> "(?:" <> Regex.escape(string) <> ")"

  @doc ~S"""
  Express a string literal to be matched exactly and wraps in a non-capturing group.
  Alias of `then/3` for readability semantics, as 'find' is a makes more sense when placed at the beginning of a pipe chain.

  **NOTE:** Under the current implementation, when using the `escape: false` option in
  pipe chains beginning with `find`, an empty string must be provided as the first value.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.find("needle") |> Vlx.if_preceded_by("hay") |> Vlx.if_followed_by("stack")
      "(?<=hay)(?:needle)(?=stack)"
  """
  @spec find(binary(), binary(), [{:escape, false}]) :: binary()
  def find(before, string, opts \\ [])

  def find(before, string, escape: false) when are_binaries(before, string),
    do: then(before, string, escape: false)

  def find(before, string, _) when are_binaries(before, string), do: then(before, string)

  @spec find(binary()) :: binary()
  def find(string) when is_binary(string), do: then("", string)

  ### Quantifiers ###

  @doc ~S"""
  Specify the number of expected occurences to be found on a given expression.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.digit() |> Vlx.capture() |> Vlx.occurs(4)
      "(\d){4}"
  """
  @spec occurs(binary(), integer()) :: binary()
  def occurs(before, n) when is_binary(before) and is_integer(n), do: before <> "{#{n}}"

  @doc ~S"""
  Specify the range of expected occurences to be found on a given expression.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.digit() |> Vlx.capture() |> Vlx.occurs_in_range(3, 6)
      "(\d){3,6}"
  """
  @spec occurs_in_range(binary(), integer(), integer()) :: binary()
  def occurs_in_range(before, min, max) when is_binary(before) and are_integers(min, max),
    do: before <> "{#{min},#{max}}"

  @doc """
  Express a pattern will occur zero or more times.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.anything_in_classes(:alnum) |> Vlx.zero_or_more()
      "[[:alnum:]]*"
  """
  @spec zero_or_more(binary(), binary(), [{:escape, false}]) :: binary()
  def zero_or_more(before, string \\ "", opts \\ [])

  def zero_or_more(before, string, escape: false) when are_binaries(before, string),
    do: before <> string <> "*"

  def zero_or_more(before, string, _) when are_binaries(before, string),
    do: before <> Regex.escape(string) <> "*"

  @doc """
  Express a pattern will occur one or more times.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.anything_in_classes(:alnum) |> Vlx.one_or_more()
      "[[:alnum:]]+"
  """
  @spec one_or_more(binary(), binary(), [{:escape, false}]) :: binary()
  def one_or_more(before, string \\ "", opts \\ [])

  def one_or_more(before, string, escape: false) when are_binaries(before, string),
    do: before <> string <> "+"

  def one_or_more(before, string, _) when are_binaries(before, string),
    do: before <> Regex.escape(string) <> "+"

  @doc ~S"""
  Express a pattern as being optional to match.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.find("colo") |> Vlx.maybe("u") |> Vlx.then("r")
      "(?:colo)u?(?:r)"
  """
  @spec maybe(binary(), binary(), [{:escape, false}]) :: binary()
  def maybe(before, string \\ "", opts \\ [])

  def maybe(before, string, escape: false) when are_binaries(before, string),
    do: before <> string <> "?"

  def maybe(before, string, _) when are_binaries(before, string),
    do: before <> Regex.escape(string) <> "?"

  ### Special Characters

  @doc ~S"""
  Matches any character. Equivalent to "."
  """
  @spec anything(binary()) :: binary()
  def anything(before \\ "") when is_binary(before), do: before <> "."

  @doc ~S"""
  Matches for any of the characters in the given string.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.anything_in_string("asdf") |> Vlx.one_or_more()
      "[asdf]+"
  """
  @spec anything_in_string(binary()) :: binary()
  def anything_in_string(string)
      when is_binary(string) do
    "[#{string}]"
  end

  @spec anything_in_string(binary(), binary()) :: binary()
  def anything_in_string(before, string)
      when are_binaries(before, string) do
    before <> "[#{string}]"
  end

  @doc ~S"""
  Matches for anything but the characters in the given string.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.anything_not_in_string("asdf") |> Vlx.one_or_more()
      "[^asdf]+"
  """
  @spec anything_not_in_string(binary()) :: binary()
  def anything_not_in_string(string)
      when is_binary(string) do
    "[^#{string}]"
  end

  @spec anything_not_in_string(binary(), binary()) :: binary()
  def anything_not_in_string(before, string)
      when are_binaries(before, string) do
    before <> "[^#{string}]"
  end

  @doc ~S"""
  Matches any of the characters in a character class.

  The supported class names are:
    * `:alnum` - Letters and digits
    * `:alpha` - Letters
    * `:ascii` - Character codes 0-127
    * `:blank` - Space or tab only
    * `:cntrl` - Control characters
    * `:digit` - Decimal digits (same as \\d)
    * `:graph` - Printing characters, excluding space
    * `:lower` - Lowercase letters
    * `:print` - Printing characters, including space
    * `:punct` - Printing characters, excluding letters, digits, and space
    * `:space` - Whitespace (the same as \s from PCRE 8.34)
    * `:upper` - Uppercase letters
    * `:word ` - "Word" characters (same as \w)
    * `:xdigit` - Hexadecimal digits

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.anything_in_classes([:upper, :digit]) |> Vlx.one_or_more()
      "[[:upper:][:digit:]]+"
  """
  @spec anything_in_classes(list(atom()) | atom()) :: binary()
  def anything_in_classes(class) when is_atom(class), do: "[[:#{class}:]]"

  def anything_in_classes(classes)
      when is_list(classes) do
    "[#{Enum.reduce(classes, &concat_class/2)}]"
  end

  @spec anything_in_classes(binary(), list(atom()) | atom()) :: binary()
  def anything_in_classes(before, class) when is_atom(class),
    do: before <> "[[:#{class}:]]"

  def anything_in_classes(before, classes)
      when is_binary(before) and is_list(classes) do
    before <> "[#{Enum.reduce(classes, &concat_class/2)}]"
  end

  @doc ~S"""
  Matches any character not covered in the given character classes.
  Supported class names match `anything_in_classes` functionality.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.anything_not_in_classes([:upper, :digit]) |> Vlx.one_or_more()
      "[^[:upper:][:digit:]]+"
  """

  @spec anything_not_in_classes(list(atom())) :: binary()
  def anything_not_in_classes(classes)
      when is_list(classes) do
    "[^#{Enum.reduce(classes, &concat_class/2)}]"
  end

  @spec anything_not_in_classes(binary(), list(atom())) :: binary()
  def anything_not_in_classes(before, classes)
      when is_binary(before) and is_list(classes) do
    before <> "[^#{Enum.reduce(classes, &concat_class/2)}]"
  end

  @spec concat_class(atom(), binary()) :: binary()
  defp concat_class(class, acc) when is_atom(acc), do: "[:#{acc}:][:#{class}:]"
  defp concat_class(class, acc), do: "#{acc}[:#{class}:]"

  @doc ~S"""
  Matches a linebreak character. Equivalent to "\n".
  """
  @spec linebreak(binary()) :: binary()
  def linebreak(before \\ "") when is_binary(before), do: before <> "\n"

  @doc ~S"""
  Matches a tab character. Equivalent to "\t".
  """
  @spec tab(binary()) :: binary()
  def tab(before \\ "") when is_binary(before), do: before <> "\t"

  @doc ~S"""
  Matches a carriage return character. Equivalent to "\r".
  """
  @spec carriage_return(binary()) :: binary()
  def carriage_return(before \\ "") when is_binary(before), do: before <> "\r"

  @doc ~S"""
  Matches a digit (0-9). Equivalent to "\d".
  """
  @spec digit(binary()) :: binary()
  def digit(before \\ "") when is_binary(before), do: before <> "\d"

  @doc ~S"""
  Matches anything but a digit (0-9). Equivalent to "\D".
  """
  @spec not_digit(binary()) :: binary()
  def not_digit(before \\ "") when is_binary(before), do: before <> "\D"

  @doc ~S"""
  Matches a 'word', equivalent to [a-zA-Z0-9_]
  """
  @spec word(binary()) :: binary()
  def word(before \\ "") when is_binary(before), do: before <> "\w"

  @doc ~S"""
  Matches a 'word boundary' - a word bounary is the position between a word and non-word character (`0-9A-Za-z_]`).
  It is commonly thought of as matching the beginning or end of a string.
  """
  @spec word_boundary(binary()) :: binary()
  def word_boundary(before \\ "") when is_binary(before), do: before <> "\b"

  @doc ~S"""
  Matches anything but a 'word', equivalent to [^a-zA-Z0-9_]
  """
  @spec not_word(binary()) :: binary()
  def not_word(before \\ "") when is_binary(before), do: before <> "\W"

  @doc ~S"""
  Matches a whitespace character - includes tabs and line breaks.
  """
  @spec whitespace(binary()) :: binary()
  def whitespace(before \\ "") when is_binary(before), do: before <> "\s"

  @doc ~S"""
  Matches anything but whitespace character - includes tabs and line breaks.
  """
  @spec not_whitespace(binary()) :: binary()
  def not_whitespace(before \\ "") when is_binary(before), do: before <> "\S"

  ### Grouping & Capturing

  @doc ~S"""
  Wraps a regex string in a capturing group.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> pattern = Vlx.find("this") |> Vlx.then("that")
      iex> Vlx.capture(pattern)
      "((?:this)(?:that))"
  """
  @spec capture(binary(), binary(), [{:escape, false}]) :: binary()
  def capture(before, string, opts \\ [])

  def capture(before, string, escape: false) when are_binaries(before, string),
    do: before <> "(" <> string <> ")"

  def capture(before, string, _) when are_binaries(before, string),
    do: before <> "(" <> Regex.escape(string) <> ")"

  def capture(before \\ "") when is_binary(before), do: "(" <> before <> ")"

  @doc ~S"""
  Wraps a regex string in a named-capturing group. To be utilised with `Regex.named_captures(regex, string, options \\ [])`.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.find("http") |> Vlx.maybe("s") |> Vlx.then("://") |> Vlx.capture_as("protocols")
      "(?<protocols>(?:http)s?(?::\/\/))"
  """
  @spec capture_as(binary(), binary()) :: binary()
  def capture_as(before, as) when are_binaries(before, as), do: "(?<#{as}>" <> before <> ")"

  @doc ~S"""
  Wraps a regex string in a non-capturing group. This facilitates easy application of
  things like quantifiers or backreferences to the entirety of a given expression.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> protocol = Vlx.find("http") |> Vlx.maybe("s") |> Vlx.then("://") |> Vlx.atomize()
      iex> Vlx.maybe(protocol) |> Vlx.then("www.")
      "(?:(?:http)s?(?:://))?(?:www\\.)"
  """
  @spec atomize(binary()) :: binary()
  def atomize(string) when is_binary(string), do: "(?:" <> string <> ")"

  @spec atomize(binary(), binary()) :: binary()
  def atomize(before, string) when are_binaries(before, string),
    do: before <> "(?:" <> string <> ")"

  ### Logic ###

  @doc ~S"""
  Takes in a list of regex strings, and inserts an or operator between each of them.
  Does not escape characters by default to preference OR-ing complex expressions and encourage composition.
  Special character escaping is available via the `escape: true` option.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> accepted_exprs = ["match", "any", "of", "these"]
      iex> Vlx.or_expressions(accepted_exprs)
      "(match|any|of|these)"
  """
  @spec or_expressions(list(binary()), binary(), [{:escape, false}]) :: binary()
  def or_expressions(subexps, string \\ "", opts \\ [])

  def or_expressions([last | []], string, escape: true) when are_binaries(last, string),
    do: "#{string}#{Regex.escape(last)})"

  def or_expressions([head | tail], "", escape: true) when is_binary(head) do
    or_expressions(tail, "(#{Regex.escape(head)}|")
  end

  def or_expressions([head | tail], string, escape: true) when are_binaries(head, string) do
    or_expressions(tail, "#{string}#{Regex.escape(head)}|")
  end

  def or_expressions([last | []], string, _) when are_binaries(last, string),
    do: "#{string}#{last})"

  def or_expressions([head | tail], "", _) when is_binary(head),
    do: or_expressions(tail, "(#{head}|")

  def or_expressions([head | tail], string, _) when are_binaries(head, string),
    do: or_expressions(tail, "#{string}#{head}|")

  ### Lookarounds ###

  @doc ~S"""
  Takes a regex string and applies a lookahead condition. Escapes special characters by default.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.find("sentence") |> Vlx.if_followed_by(".") |> Vlx.capture()
      "((?:sentence)(?=\\.))"
  """
  @spec if_followed_by(binary(), binary(), [{:escape, false}]) :: binary()
  def if_followed_by(before, string, opts \\ [])

  def if_followed_by(before, string, escape: false) when are_binaries(before, string) do
    before <> "(?=" <> string <> ")"
  end

  def if_followed_by(before, string, _) when are_binaries(before, string) do
    before <> "(?=" <> Regex.escape(string) <> ")"
  end

  @doc ~S"""
  Takes a regex string and applies a negative lookahead condition. Escapes special characters by default.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.find("good") |> Vlx.if_not_followed_by("bye") |> Vlx.capture()
      "((?:good)(?!bye))"
  """
  @spec if_not_followed_by(binary(), binary(), [{:escape, false}]) :: binary()
  def if_not_followed_by(before, string, opts \\ [])

  def if_not_followed_by(before, string, escape: false) when are_binaries(before, string) do
    before <> "(?!" <> string <> ")"
  end

  def if_not_followed_by(before, string, _) when are_binaries(before, string) do
    before <> "(?!" <> Regex.escape(string) <> ")"
  end

  @doc ~S"""
  Takes a regex string and applies a lookbehind condition. Escapes special characters by default.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.digit() |> Vlx.if_preceded_by("$") |> Vlx.capture()
      "((?<=\\$)\d)"
  """
  @spec if_preceded_by(binary(), binary(), [{:escape, false}]) :: binary()
  def if_preceded_by(before, string, opts \\ [])

  def if_preceded_by(before, string, escape: false) when are_binaries(before, string) do
    "(?<=" <> string <> ")" <> before
  end

  def if_preceded_by(before, string, _) when are_binaries(before, string) do
    "(?<=" <> Regex.escape(string) <> ")" <> before
  end

  @doc ~S"""
  Takes a regex string and applies a negative lookbehind condition. Escapes special characters by default.

  ## Examples

      iex> alias Verbalex, as: Vlx
      iex> Vlx.digit() |> Vlx.if_not_preceded_by("%") |> Vlx.capture()
      "((?<!%)\d)"
  """
  @spec if_not_preceded_by(binary(), binary(), [{:escape, false}]) :: binary()
  def if_not_preceded_by(before, string, opts \\ [])

  def if_not_preceded_by(before, string, escape: false) when are_binaries(before, string) do
    "(?<!" <> string <> ")" <> before
  end

  def if_not_preceded_by(before, string, _) when are_binaries(before, string) do
    "(?<!" <> Regex.escape(string) <> ")" <> before
  end
end

defmodule Intercom.Escaping do
  @escapes [
    {?<, "\\u003c"},
    {?>, "\\u003e"},
    {?&, "\\u0026"}
  ]

  def html_escape(data) when is_binary(data) do
    IO.iodata_to_binary(for <<char <- data>>, do: escape_char(char))
  end

  Enum.each @escapes, fn { match, insert } ->
    defp escape_char(unquote(match)), do: unquote(insert)
  end

  defp escape_char(char), do: char
end

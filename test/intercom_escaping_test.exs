defmodule IntercomEscapingTest do
  use ExUnit.Case
  require Intercom.Escaping

  test "escaping dangerous characters" do
    assert "\\u003c \\u003e \\u0026" == Intercom.Escaping.html_escape("< > &")
  end
end

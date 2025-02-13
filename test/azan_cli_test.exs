defmodule AzanCliTest do
  use ExUnit.Case
  doctest AzanCli

  test "greets the world" do
    assert AzanCli.hello() == :world
  end
end

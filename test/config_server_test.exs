defmodule ConfigServerTest do
  use ExUnit.Case
  doctest ConfigServer

  test "greets the world" do
    assert ConfigServer.hello() == :world
  end
end

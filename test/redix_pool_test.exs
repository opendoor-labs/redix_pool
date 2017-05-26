defmodule RedixPoolTest do
  use ExUnit.Case
  doctest RedixPool

  alias RedixPool, as: Redix

  setup do
    Redix.command(["FLUSHDB"])
    :ok
  end

  test "basic command method" do
    assert Redix.command(["SET", "foo", "bar"]) == {:ok, "OK"}
    assert Redix.command(["GET", "foo"]) == {:ok, "bar"}

    assert Redix.command(["HSET", "foobar", "field", "value"]) == {:ok, 1}
    assert Redix.command(["HGET", "foobar", "field"]) == {:ok, "value"}
  end

  test "basic command! method" do
    assert Redix.command!(["SET", "foo", "bar"]) == "OK"
    assert Redix.command!(["GET", "foo"]) == "bar"

    assert Redix.command!(["HSET", "foobar", "field", "value"]) == 1
    assert Redix.command!(["HGET", "foobar", "field"]) == "value"
  end

  test "basic pipeline method" do
    assert Redix.pipeline([["SET", "foo", "bar"],
                           ["SET", "baz", "bat"]]) == {:ok, ["OK", "OK"]}
    assert Redix.command(["GET", "foo"]) == {:ok, "bar"}
    assert Redix.command(["GET", "baz"]) == {:ok, "bat"}

    assert Redix.pipeline([["HSET", "foobar", "foo", "bar"],
                           ["HSET", "foobar", "baz", "bat"]]) == {:ok, [1, 1]}
    assert Redix.command(["HGET", "foobar", "foo"]) == {:ok, "bar"}
    assert Redix.command(["HGET", "foobar", "baz"]) == {:ok, "bat"}
  end

  test "basic pipeline! method" do
    assert Redix.pipeline!([["SET", "foo", "bar"],
                            ["SET", "baz", "bat"]]) == ["OK", "OK"]
    assert Redix.command(["GET", "foo"]) == {:ok, "bar"}
    assert Redix.command(["GET", "baz"]) == {:ok, "bat"}

    assert Redix.pipeline!([["HSET", "foobar", "foo", "bar"],
                            ["HSET", "foobar", "baz", "bat"]]) == [1, 1]
    assert Redix.command(["HGET", "foobar", "foo"]) == {:ok, "bar"}
    assert Redix.command(["HGET", "foobar", "baz"]) == {:ok, "bat"}
  end
end

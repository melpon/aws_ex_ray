defmodule AwsExRay.Test.TraceTest do
  use ExUnit.Case, async: true

  alias AwsExRay.Trace

  test "trace format" do
    t = Trace.new()
    assert "#{t}" == "Root=#{t.root};Sampled=1"

    t = %{t|sampled: false}
    assert "#{t}" == "Root=#{t.root};Sampled=0"

    t = %{t|parent: "foobar"}
    assert "#{t}" == "Root=#{t.root};Parent=foobar;Sampled=0"

  end

  test "parsing trace value" do
    assert Trace.parse("") == {:error, :not_found}

    {:ok, t1} = Trace.parse("Root=hoge;Sampled=1")
    assert t1.root == "hoge"
    assert t1.sampled == true
    assert t1.parent == ""

    {:ok, t2} = Trace.parse("Root=hoge;Parent=foobar;Sampled=1")
    assert t2.root == "hoge"
    assert t2.sampled == true
    assert t2.parent == "foobar"

    {:ok, t3} = Trace.parse("Root=hoge;Parent=foobar;Sampled=0")
    assert t3.root == "hoge"
    assert t3.sampled == false
    assert t3.parent == "foobar"

    {:ok, t4} = Trace.parse("Root=hoge")
    assert t4.root == "hoge"
    assert t4.sampled == false
    assert t4.parent == ""

    assert Trace.parse("Parent=foobar;Sampled=1") == {:error, :not_found}
  end

end

defmodule AwsExRay.Test.HTTPoisonTest do

  use ExUnit.Case
  doctest AwsExRay

  setup do
    AwsExRay.Test.Mox.setup_default()
    :ok
  end

  test "greets the world" do

    trace = AwsExRay.Trace.new()
    segment = AwsExRay.start_tracing(trace, "dummy_trace_name")

    result = AwsExRay.HTTPoison.get! "http://httparrot.herokuapp.com/get"

    AwsExRay.finish_tracing(segment)

    assert result == {:ok, ""}

  end

end
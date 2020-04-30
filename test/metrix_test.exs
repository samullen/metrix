defmodule MetrixTest do
  use ExUnit.Case

  import Metrix

  setup_all do
    :telemetry.attach("test_id", [:test, :event], &event_handler/4, nil)

    :ok
  end

  describe "measure/2" do
    test "returns the result of code block being measured" do
      result = measure [:test, :event], do: 6 * 9

      assert result == 54
    end

    test "sends telemetry data to specified event name" do
      measure [:test, :event], do: 6 * 9

      assert_receive {[:test, :event], _measurement, _metadata}
    end

    test "captures the measurement" do
      measure [:test, :event], do: 6 * 9

      assert_receive {_event, %{duration: duration}, _metadata}
      assert duration < 10
    end

    test "returns map metadata as the map" do
      measure [:test, :event], do: %{result: 42}

      assert_receive {_event, _measurement, metadata}
      assert metadata == %{result: 42}
    end

    test "returns non-map metadata as a map with ':response' as key" do
      measure [:test, :event], do: 42

      assert_receive {_event, _measurement, metadata}
      assert metadata == %{response: 42}
    end
  end

  defp event_handler([:test, :event], measurement, metadata, _config) do
    send self(), {[:test, :event], measurement, metadata}
  end
end

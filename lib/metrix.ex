defmodule Metrix do
  defmacro __using__(_opts) do
    quote do
      import Metrix
    end
  end

  defmacro measure(event, metadata \\ Macro.escape(%{}), do: block) do
    quote do
      case :timer.tc(fn -> unquote(block) end) do
        {time, response} ->
          metadata = Map.put(unquote(metadata), :response, response)

          :telemetry.execute(unquote(event), %{duration: time}, metadata)

          response
      end
    end
  end
end

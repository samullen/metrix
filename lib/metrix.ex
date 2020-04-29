defmodule Metrix do
  defmacro __using__(_opts) do
    quote do
      import Metrix
    end
  end

  defmacro measure(event, do: block) do
    quote do
      case :timer.tc(fn -> unquote(block) end) do
        {time, response} when is_map(response) ->
          :telemetry.execute(unquote(event), %{duration: time}, response)
          response

        {time, response} ->
          :telemetry.execute(unquote(event), %{duration: time}, %{
            response: response
          })

          response
      end
    end
  end
end

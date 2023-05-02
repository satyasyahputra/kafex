defmodule Kafex.ConsumerWorkers.Echo.Worker do
  def processor(payload) do
    IO.inspect(payload)
  end
end

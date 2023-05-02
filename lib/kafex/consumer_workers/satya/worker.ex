defmodule Kafex.ConsumerWorkers.Satya.Worker do
  import Kafex.Message

  def processor(payload) do
    IO.inspect("satya - #{kafka_message(payload, :value)}")
  end
end

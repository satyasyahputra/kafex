defmodule Kafex.Message do
  require Record

  Record.defrecord(
    :kafka_message,
    offset: nil,
    key: nil,
    value: nil,
    ts_type: nil,
    ts: nil,
    headers: []
  )
end

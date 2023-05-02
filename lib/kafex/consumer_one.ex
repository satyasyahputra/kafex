defmodule Kafex.GroupSubscriber do
  require Logger
  require Record
  import Kafex.Message

  def child_spec(topic, group) do
    %{
      id: Kafex.GroupSubscriber,
      start: {Kafex.GroupSubscriber, :start_link, [topic, group]}
    }
  end

  def start_link(topic, group) do
    group_config = [
      offset_commit_policy: :commit_to_kafka_v2,
      offset_commit_interval_seconds: 5,
      rejoin_delay_seconds: 2,
      reconnect_cool_down_seconds: 10
    ]

    {:ok, _subscriber} =
      :brod.start_link_group_subscriber(
        :kafka_client,
        group,
        [topic],
        group_config,
        _consumer_config = [begin_offset: :earliest],
        _callback_module = __MODULE__,
        _callback_init_args = []
      )
  end

  def init(_group_id, callback_init_args) do
    {:ok, callback_init_args}
  end

  def handle_message(
        _topic,
        _partition,
        {:kafka_message, _offset, _key, body, _op, _timestamp, []} = message,
        state
      ) do
    Logger.info("Message #{body}")
    Logger.info("Message #{inspect(state)}")

    case body do
      "error_bodyy" -> :error
      _ -> {:ok, :ack, state}
    end
  end
end

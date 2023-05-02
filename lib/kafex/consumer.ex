defmodule Kafex.Consumer do
  @behaviour :brod_group_subscriber_v2

  def child_spec(
        %{
          name: name,
          worker_module: worker_module
        } = _opts
      ) do
    client = String.to_atom("#{name}_client")

    :ok =
      start_brod_client(%{
        client: client
      })

    config = %{
      client: client,
      group_id: get_consumergroup(name),
      topics: get_topics(name),
      cb_module: __MODULE__,
      consumer_config: [{:begin_offset, :earliest}],
      init_data: %{
        worker_module: worker_module
      },
      message_type: :message,
      group_config: [
        offset_commit_policy: :commit_to_kafka_v2,
        offset_commit_interval_seconds: 5,
        rejoin_delay_seconds: 5,
        reconnect_cool_down_seconds: 20
      ]
    }

    %{
      id: __MODULE__,
      start: {:brod_group_subscriber_v2, :start_link, [config]},
      type: :worker,
      restart: :temporary,
      shutdown: 5000
    }
  end

  @impl :brod_group_subscriber_v2
  def init(group_id, init_data), do: {:ok, Map.merge(init_data, %{consumergroup: group_id})}

  @impl :brod_group_subscriber_v2
  def handle_message(message, state) do
    apply(state.worker_module, :processor, [message])
    {:ok, :commit, state}
  end

  defp start_brod_client(%{client: client}) do
    brod_client = get_brod_client()
    :brod.start_client(brod_client.endpoints, client)
  end

  defp get_brod_client(client \\ :brod_client) do
    clients = Application.fetch_env!(:brod, :clients) |> Enum.into(%{})
    clients[client] |> Enum.into(%{})
  end

  defp consumer_config(name) do
    Application.fetch_env!(:kafex, String.to_atom("#{name}_subscriber"))
    |> Enum.into(%{})
  end

  defp get_consumergroup(name) do
    consumer_config(name).consumer_group
  end

  defp get_topics(name) do
    String.split(consumer_config(name).topic, ",")
  end
end

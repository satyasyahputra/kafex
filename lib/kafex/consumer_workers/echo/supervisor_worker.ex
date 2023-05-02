defmodule Kafex.ConsumerWorkers.Echo.SupervisorWorker do
  use Supervisor

  def start_link([]) do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      Kafex.Consumer.child_spec(%{
        name: :echo,
        worker_module: Kafex.ConsumerWorkers.Echo.Worker
      })
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

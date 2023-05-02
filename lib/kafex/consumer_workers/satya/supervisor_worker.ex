defmodule Kafex.ConsumerWorkers.Satya.SupervisorWorker do
  use Supervisor

  def start_link([]) do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      Kafex.Consumer.child_spec(%{
        name: :satya,
        worker_module: Kafex.ConsumerWorkers.Satya.Worker
      })
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

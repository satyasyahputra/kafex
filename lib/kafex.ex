defmodule Kafex do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Kafex.Worker.start_link(arg)
      # {Kafex.Worker, arg}
      Kafex.ConsumerWorkers.Echo.SupervisorWorker,
      Kafex.ConsumerWorkers.Satya.SupervisorWorker
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kafex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

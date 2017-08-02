defmodule Iris.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Iris.Repo, []),
      supervisor(IrisWeb.Endpoint, []),
      # supervisor(Mqtt.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Iris.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    IrisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

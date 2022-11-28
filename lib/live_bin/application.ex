defmodule LiveBin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Telemetry supervisor
      LiveBinWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveBin.PubSub},
      {Registry, keys: :unique, name: LiveBin.Requests.Bin.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: LiveBin.Requests.Bin.Supervisor},
      # Start the endpoint when the application starts
      LiveBinWeb.Endpoint
      # Starts a worker by calling: LiveBin.Worker.start_link(arg)
      # {LiveBin.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveBin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LiveBinWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

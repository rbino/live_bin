defmodule MFPB.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Telemetry supervisor
      MFPBWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MFPB.PubSub},
      {Registry, keys: :unique, name: MFPB.Requests.Bin.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: MFPB.Requests.Bin.Supervisor},
      # Start the endpoint when the application starts
      MFPBWeb.Endpoint
      # Starts a worker by calling: MFPB.Worker.start_link(arg)
      # {MFPB.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MFPB.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MFPBWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

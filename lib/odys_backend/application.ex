defmodule OdysBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OdysBackendWeb.Telemetry,
      OdysBackend.Repo,
      {DNSCluster, query: Application.get_env(:odys_backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OdysBackend.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: OdysBackend.Finch},
      # Start a worker by calling: OdysBackend.Worker.start_link(arg)
      # {OdysBackend.Worker, arg},
      # Start to serve requests, typically the last entry
      OdysBackendWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OdysBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OdysBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

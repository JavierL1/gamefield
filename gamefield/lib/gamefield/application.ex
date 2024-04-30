defmodule Gamefield.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GamefieldWeb.Telemetry,
      Gamefield.Repo,
      {DNSCluster, query: Application.get_env(:gamefield, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Gamefield.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Gamefield.Finch},
      # Start a worker by calling: Gamefield.Worker.start_link(arg)
      # {Gamefield.Worker, arg},
      # Start to serve requests, typically the last entry
      GamefieldWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gamefield.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GamefieldWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

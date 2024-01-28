defmodule EchoRequest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EchoRequestWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:echo_request, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EchoRequest.PubSub},
      # Start a worker by calling: EchoRequest.Worker.start_link(arg)
      # {EchoRequest.Worker, arg},
      # Start to serve requests, typically the last entry
      EchoRequestWeb.Endpoint,
      {Registry, [keys: :unique, name: :token_registry]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EchoRequest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EchoRequestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

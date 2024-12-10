defmodule NoteRy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NoteRyWeb.Telemetry,
      NoteRy.Repo,
      {DNSCluster, query: Application.get_env(:note_ry, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: NoteRy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: NoteRy.Finch},
      # Start a worker by calling: NoteRy.Worker.start_link(arg)
      # {NoteRy.Worker, arg},
      # Start to serve requests, typically the last entry
      NoteRyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NoteRy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NoteRyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

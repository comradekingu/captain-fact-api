defmodule CaptainFactGraphql.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Start by configuring the app with runtime configuration (env + secrets)
    secrets_path = if File.exists?("/run/secrets"), do: "/run/secrets", else: Path.join(:code.priv_dir(:captain_fact_graphql), "secrets")
    Application.put_env(:weave, :file_directory, secrets_path)
    CaptainFactGraphql.RuntimeConfiguration.configure()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(CaptainFactGraphqlWeb.Endpoint, []),
      # Start your own worker by calling: CaptainFactGraphql.Worker.start_link(arg1, arg2, arg3)
      # worker(CaptainFactGraphql.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CaptainFactGraphql.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CaptainFactGraphqlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Exd.Repo.Supervisor do
  @moduledoc false
  use Supervisor

  @doc """
  Starts repo supervisor
  """
  def start_link(repo, otp_app, opts) do
    sup_opts = [name: repo]
    Supervisor.start_link(__MODULE__, {repo, otp_app, opts}, sup_opts)
  end

  @impl true
  def init({repo, otp_app, opts}) do
    supervise([
      repo_spec(repo)
    ], strategy: :one_for_one, max_restarts: 0)
  end

  defp repo_spec(repo) do
    %{
      start: {repo, :start_link, []}
    }
  end

end

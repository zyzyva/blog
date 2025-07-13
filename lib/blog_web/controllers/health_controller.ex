defmodule BlogWeb.HealthController do
  use BlogWeb, :controller

  def index(conn, _params) do
    # Check database connectivity
    db_status = check_database()
    
    health_status = %{
      status: if(db_status == :ok, do: "healthy", else: "unhealthy"),
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      version: "1.0.0",
      checks: %{
        database: db_status
      }
    }
    
    status_code = if health_status.status == "healthy", do: 200, else: 503
    
    conn
    |> put_status(status_code)
    |> json(health_status)
  end
  
  defp check_database do
    try do
      # Simple query to check database connectivity
      case Blog.Repo.query("SELECT 1") do
        {:ok, _} -> :ok
        {:error, _} -> :error
      end
    rescue
      _ -> :error
    end
  end
end
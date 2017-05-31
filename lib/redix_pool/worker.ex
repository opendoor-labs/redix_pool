defmodule RedixPool.Worker do
  use GenServer

  alias RedixPool.Config

  @redis_url "redis://localhost:6379"

  ## Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{conn: nil}, [])
  end

  ## Server API

  def init(state) do
    {:ok, state}
  end

  @doc false
  def handle_call({command, args, opts}, _from, %{conn: nil}) do
    conn = connect()
    {:reply, apply(Redix, command, [conn, args, opts]), %{conn: conn}}
  end

  @doc false
  def handle_call({command, args, opts}, _from, %{conn: conn}) do
    {:reply, apply(Redix, command, [conn, args, opts]), %{conn: conn}}
  end

  defp connect do
    redis_url = Config.get(:redis_url, @redis_url)
    {:ok, conn} = Redix.start_link(redis_url)
    conn
  end
end

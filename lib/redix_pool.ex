defmodule RedixPool do
  @moduledoc """
  Documentation for RedixPool.
  """
  use Application

  alias RedixPool.Config

  @pool_name :redix_pool

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    pool_options = [
      name: {:local, @pool_name},
      worker_module: RedixPool.Worker,
      size: Config.get(:pool_size, 10),
      max_overflow: Config.get(:pool_max_overflow, 1)
    ]

    children = [
      :poolboy.child_spec(@pool_name, pool_options, [])
    ]

    opts = [strategy: :one_for_one, name: RedixPool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def command(args, opts \\ []) do
    :poolboy.transaction(
      @pool_name,
      fn(worker) -> GenServer.call(worker, {:command, args, opts}) end,
      RedixPool.Config.get(:timeout, 5000)
    )
  end

  def command!(args, opts \\ []) do
    :poolboy.transaction(
      @pool_name,
      fn(worker) -> GenServer.call(worker, {:command!, args, opts}) end,
      Config.get(:timeout, 5000)
    )
  end

  def pipeline(args, opts \\ []) do
    :poolboy.transaction(
      @pool_name,
      fn(worker) -> GenServer.call(worker, {:pipeline, args, opts}) end,
      Config.get(:timeout, 5000)
    )
  end

  def pipeline!(args, opts \\ []) do
    :poolboy.transaction(
      @pool_name,
      fn(worker) -> GenServer.call(worker, {:pipeline!, args, opts}) end,
      RedixPool.Config.get(:timeout, 5000)
    )
  end
end

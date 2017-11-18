defmodule RedixPool.Config do
  @default_config %{
    pool_name: :redix_pool,
    max_overflow: 1,
    pool_size: 10,
    redis_url: "redis://localhost:6379",
    timeout: 5000
  }

  @doc false
  def get(key) do
    get(key, Map.get(@default_config, key))
  end
  def get(key, fallback) do
    case Application.get_env(:redix_pool, key, fallback) do
      {:system, varname} -> System.get_env(varname)
      {:system, varname, default} -> System.get_env(varname) || default
      value -> value
    end
  end
end

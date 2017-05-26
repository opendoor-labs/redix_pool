defmodule RedixPool.Config do
  @doc false
  def get(key, default \\ nil) do
    :redix_pool
    |> Application.get_env(key, default)
    |> resolve_config(default)
  end

  @doc false
  def resolve_config({:system, var_name}, default),
    do: System.get_env(var_name) || default
  def resolve_config(value, _default),
    do: value
end

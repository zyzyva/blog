defmodule Blog.Cache do
  @moduledoc """
  Simple cache implementation using Cachex with TTL support.
  """

  @cache_name :blog_cache

  def put(key, value, ttl \\ nil) do
    ttl = ttl || Application.get_env(:blog, :cache_ttl)
    Cachex.put(@cache_name, key, value, ttl: ttl)
    value
  end

  def get(key) do
    case Cachex.get(@cache_name, key) do
      {:ok, nil} -> {:error, :not_found}
      {:ok, value} -> {:ok, value}
      {:error, _} -> {:error, :not_found}
    end
  end

  def delete(key) do
    Cachex.del(@cache_name, key)
  end
end

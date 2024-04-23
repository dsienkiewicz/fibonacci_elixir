defmodule FibonacciElixir.Calculations.BlacklistStore do
  @moduledoc """
  This module is responsible for storing and managing the blacklist of numbers for calculations.

  The blacklist is a list of input values that should not be returned from calculations.
  """
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)
  end

  @doc """
  Returns the current blacklist as list.
  """
  @spec get() :: [pos_integer()]
  def get(), do: Agent.get(__MODULE__, fn state -> MapSet.to_list(state) end)

  @doc """
  Checks if a number exists in the blacklist.
  """
  @spec exists?(pos_integer()) :: boolean()
  def exists?(n), do: Agent.get(__MODULE__, fn state -> MapSet.member?(state, n) end)

  @doc """
  Adds a number to the blacklist.
  """
  @spec put(pos_integer()) :: :ok
  def put(n), do: Agent.update(__MODULE__, fn state -> MapSet.put(state, n) end)

  @doc """
  Deletes a number from the blacklist.
  """
  @spec delete(pos_integer()) :: :ok
  def delete(n), do: Agent.update(__MODULE__, fn state -> MapSet.delete(state, n) end)
end

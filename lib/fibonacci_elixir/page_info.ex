defmodule FibonacciElixir.PageInfo do
  @moduledoc """
  Module for the page info - used for page-based pagination.
  """
  use FibonacciElixir.Utils.TypedEmbeddedSchema

  typed_embedded_schema do
    field(:page, :integer) :: pos_integer()
    field(:size, :integer) :: pos_integer()
  end

  @doc """
  Returns the default page info.
  """
  @spec default() :: PageInfo.t()
  def default() do
    %__MODULE__{
      page: 1,
      size: 100
    }
  end
end

defmodule ConfigServer.Storage.BinaryTerm do
  @moduledoc """
    This module stores data using :erlang.term_to_binary.
  """

  @behaviour ConfigServer.Storage

  @impl ConfigServer.Storage
  def save(path, data) do
    binary = :erlang.term_to_binary(data)
    File.write(path, binary)
  end

  @impl ConfigServer.Storage
  def load(path) do
    with {:ok, binary} <- File.read(path) do
      try do
        {:ok, :erlang.binary_to_term(binary)}
      rescue
        e in ArgumentError -> {:error, e.message}
      end
    end
  end
end

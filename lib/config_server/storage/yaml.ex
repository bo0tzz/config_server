defmodule ConfigServer.Storage.Yaml do
  @moduledoc """
    This module loads and stores data in YAML format
  """

  @behaviour ConfigServer.Storage

  @impl ConfigServer.Storage
  def save(path, data) do
    with {:ok, binary} <- Ymlr.document(data) do
      File.write(path, binary)
    end
  end

  @impl ConfigServer.Storage
  def load(path) do
    with {:ok, binary} <- File.read(path) do
      YamlElixir.read_from_string(binary)
    end
  end
end

defmodule ConfigServer.Storage do
  @moduledoc false

  @callback save(Path.t(), term) :: :ok | {:error, String.t()}
  @callback load(Path.t()) :: {:ok, term} | {:error, String.t()}
end

defmodule ConfigServer do
  @moduledoc """
  Documentation for `ConfigServer`.
  """

  require Mixin

  def start_link(opts), do: ConfigServer.Server.start_link(opts)

  Mixin.include(Agent,
    only: [:cast, :get, :get_and_update, :stop, :update]
  )
end

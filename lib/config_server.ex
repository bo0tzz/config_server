defmodule ConfigServer do
  @moduledoc """
  Documentation for `ConfigServer`.
  """

  require Mixin

  def child_spec(opts) do
    ConfigServer.Server.child_spec(opts)
  end

  Mixin.include(Agent,
    only: [:cast, :get, :get_and_update, :stop, :update]
  )
end

defmodule ConfigServer.Server do
  use GenServer
  alias ConfigServer.Server

  defstruct [:path, :storage, :data]

  def start_link(options), do: GenServer.start_link(__MODULE__, options, options)

  @impl true
  def init(options) do
    with {:ok, path} <- Keyword.fetch(options, :path),
         default_fn <- Keyword.get(options, :default_fn, fn -> nil end),
         true <- is_function(default_fn, 0),
         storage <- Keyword.get(options, :storage, ConfigServer.Storage.BinaryTerm) do
      Process.flag(:trap_exit, true)

      data =
        case storage.load(path) do
          {:ok, data} -> data
          {:error, :enoent} -> default_fn.()
        end

      state = %Server{
        path: path,
        storage: storage,
        data: data
      }

      {:ok, state}
    end
  end

  def save(%Server{path: path, storage: storage, data: data}), do: :ok = storage.save(path, data)

  @impl true
  def terminate(_, state), do: save(state)

  @impl true
  def handle_continue(:save, state) do
    save(state)
    {:noreply, state}
  end

  @impl true
  def handle_call({:get, fun}, _from, %Server{data: data} = state) do
    {:reply, run(fun, [data]), state}
  end

  @impl true
  def handle_call({:get_and_update, fun}, _from, %Server{data: data} = state) do
    case run(fun, [data]) do
      {reply, data} -> {:reply, reply, %{state | data: data}, {:continue, :save}}
      other -> {:stop, {:bad_return_value, other}, state}
    end
  end

  @impl true
  def handle_call({:update, fun}, _from, %Server{data: data} = state) do
    state = %{state | data: run(fun, [data])}
    {:reply, :ok, state, {:continue, :save}}
  end

  @impl true
  def handle_cast({:cast, fun}, %Server{data: data} = state) do
    state = %{state | data: run(fun, [data])}
    {:noreply, state, {:continue, :save}}
  end

  defp run({m, f, a}, data), do: apply(m, f, data ++ a)
  defp run(fun, data), do: apply(fun, data)
end

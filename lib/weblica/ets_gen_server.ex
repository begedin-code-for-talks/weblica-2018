defmodule Weblica.ETSGenServer do
  @name __MODULE__

  # API

  def start_link(ets_table) do
    GenServer.start_link(__MODULE__, ets_table, name: @name)
  end

  def add() do
    GenServer.cast(@name, :add)
  end

  def remove() do
    GenServer.cast(@name, :remove)
  end

  def crash() do
    GenServer.cast(@name, :crash)
  end

  def list() do
    GenServer.call(@name, :list)
  end

  # Callbacks

  def init(table) do
    case :ets.lookup(table, :tokens) do
      [{:tokens, tokens}] ->
        {:ok, {table, tokens}}

      [] ->
        :ets.insert(table, {:tokens, []})
        {:ok, {table, []}}
    end
  end

  def handle_cast(:add, {table, tokens}) do
    tokens = tokens |> Weblica.Token.add()
    :ets.insert(table, {:tokens, tokens})
    {:noreply, {table, tokens}}
  end

  def handle_cast(:remove, {table, tokens}) do
    tokens = tokens |> Weblica.Token.remove!()
    :ets.insert(table, {:tokens, tokens})
    {:noreply, {table, tokens}}
  end

  def handle_cast(:crash, {table, tokens}) do
    tokens = tokens |> Weblica.Token.crash!()
    {:noreply, {table, tokens}}
  end

  def handle_call(:list, _from, {table, tokens}) do
    {:reply, tokens, {table, tokens}}
  end
end

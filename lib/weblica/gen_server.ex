defmodule Weblica.GenServer do
  @name __MODULE__

  # API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
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

  def init(:ok) do
    {:ok, []}
  end

  def handle_cast(:add, state) do
    {:noreply, state |> Weblica.Token.add()}
  end

  def handle_cast(:remove, state) do
    {:noreply, state |> Weblica.Token.remove!()}
  end

  def handle_cast(:crash, state) do
    state |> Weblica.Token.crash!()
    {:noreply, state}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end
end

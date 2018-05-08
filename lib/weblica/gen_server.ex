defmodule Weblica.GenServer do
  @name __MODULE__

  # API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def feed() do
    GenServer.cast(@name, :feed)
  end

  def eat() do
    GenServer.cast(@name, :eat)
  end

  def punch() do
    GenServer.cast(@name, :punch)
  end

  def list() do
    GenServer.call(@name, :list)
  end

  # Callbacks

  def init(:ok) do
    {:ok, []}
  end

  def handle_cast(:feed, state) do
    {:noreply, state |> Weblica.Feeder.feed()}
  end

  def handle_cast(:eat, state) do
    {:noreply, state |> Weblica.Feeder.eat!()}
  end

  def handle_cast(:punch, state) do
    state |> Weblica.Feeder.punch!()
    {:noreply, state}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end
end

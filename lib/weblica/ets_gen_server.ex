defmodule Weblica.ETSGenServer do
  @name __MODULE__

  # API

  def start_link(ets_table) do
    GenServer.start_link(__MODULE__, ets_table, name: @name)
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

  def init(table) do
    case :ets.lookup(table, :food) do
      [{:food, food}] ->
        {:ok, {table, food}}

      [] ->
        :ets.insert(table, {:food, []})
        {:ok, {table, []}}
    end
  end

  def handle_cast(:feed, {table, food}) do
    food = food |> Weblica.Feeder.feed()
    :ets.insert(table, {:food, food})
    {:noreply, {table, food}}
  end

  def handle_cast(:eat, {table, food}) do
    food = food |> Weblica.Feeder.eat!()
    :ets.insert(table, {:food, food})
    {:noreply, {table, food}}
  end

  def handle_cast(:punch, {table, food}) do
    food = food |> Weblica.Feeder.punch!()
    {:noreply, {table, food}}
  end

  def handle_call(:list, _from, {table, food}) do
    {:reply, food, {table, food}}
  end
end

defmodule Weblica.Basic do
  def start_link() do
    {:ok, spawn_link(__MODULE__, :loop, [[]])}
  end

  def loop(state) do
    receive do
      :feed ->
        state |> Weblica.Feeder.feed() |> loop()

      :eat ->
        state |> Weblica.Feeder.eat!() |> loop()

      :punch ->
        state |> Weblica.Feeder.punch!() |> loop()

      {:list, pid} ->
        send(pid, {:ok, state})
        state |> loop()
    end
  end
end

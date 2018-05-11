defmodule Weblica.Basic do
  def start_link() do
    {:ok, spawn_link(__MODULE__, :loop, [[]])}
  end

  def loop(state) do
    receive do
      :add ->
        state |> Weblica.Token.add() |> loop()

      :remove ->
        state |> Weblica.Token.remove!() |> loop()

      :crash ->
        state |> Weblica.Token.crash!() |> loop()

      {:list, pid} ->
        send(pid, {:ok, state})
        state |> loop()
    end
  end
end

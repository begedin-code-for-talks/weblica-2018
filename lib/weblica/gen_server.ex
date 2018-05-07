defmodule Weblica.GenServer do
  @name __MODULE__

  # API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def shorten(url) do
    GenServer.cast(@name, {:shorten, url})
  end

  def unshorten(url) do
    GenServer.cast(@name, {:unshorten, url})
  end

  def list() do
    GenServer.call(@name, :list) |> IO.inspect()
  end

  # Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:shorten, url}, state) do
    {:noreply, state |> Map.put_new(url |> sanitize(), Weblica.StringGenerator.string_of_length(5))}
  end

  def handle_cast({:unshorten, url}, state) do
    {:noreply, state |> Map.delete(url)}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  defp sanitize("https://" <> rest), do: "https://" <> rest
  defp sanitize("http://" <> rest), do: "https://" <> rest
  defp sanitize(url), do: "https://" <> url
end

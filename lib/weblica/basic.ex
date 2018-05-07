defmodule Weblica.Basic do
  def start_link() do
    {:ok, spawn_link(__MODULE__, :loop, [%{}])} |> IO.inspect()
  end

  def loop(state) do
    receive do
      {:shorten, url} -> state |> Map.put_new(url |> sanitize(), Weblica.StringGenerator.string_of_length(5)) |> loop()
      {:unshorten, url} -> state |> Map.drop(url) |> loop()
      {:list, pid} ->
        send(pid, {:ok, state})
        state |> loop()
    end
  end

  defp sanitize("https://" <> rest), do: "https://" <> rest
  defp sanitize("http://" <> rest), do: "https://" <> rest
  defp sanitize(url), do: "https://" <> url
end

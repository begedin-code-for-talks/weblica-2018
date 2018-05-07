defmodule Weblica.StringGenerator do
  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")

  def string_of_length(length) do
    (1..length)
    |> Enum.reduce([], fn (_i, acc) -> [Enum.random(@chars) | acc] end)
    |> Enum.join("")
  end
end

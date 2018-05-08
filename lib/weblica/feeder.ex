defmodule Weblica.FeederError do
  defexception [:message]
end

defmodule Weblica.Feeder do
  def feed(list) do
    list |> List.insert_at(-1, "+")
  end

  def eat!([]), do: raise(Weblica.FeederError, "Nothing to eat!")
  def eat!(food) when is_list(food), do: food |> List.delete_at(-1)

  def punch!(_), do: raise(Weblica.FeederError, "Ouch!")
end

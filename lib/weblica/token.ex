defmodule Weblica.TokenError do
  defexception [:message]
end

defmodule Weblica.Token do
  def add(list), do: ["+" | list]

  def remove!([]), do: raise(Weblica.TokenError, "No tokens left!")
  def remove!([first | rest]), do: rest

  def crash!(_), do: raise(Weblica.TokenError, "Intentional crash!")
end

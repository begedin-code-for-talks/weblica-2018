defmodule WeblicaWeb.GenServerChannel do
  use Phoenix.Channel

  def join("genServer:lobby", _message, socket) do
    {:ok, Weblica.GenServer.list(), socket}
  end

  def handle_in("shorten", %{"body" => body}, socket) do
    Weblica.GenServer.shorten(body)

    socket |> broadcast!("state", Weblica.GenServer.list() |> IO.inspect)

    {:noreply, socket}
  end
end

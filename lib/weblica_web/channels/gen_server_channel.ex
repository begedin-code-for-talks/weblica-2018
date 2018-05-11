defmodule WeblicaWeb.GenServerChannel do
  use Phoenix.Channel

  def join("genServer:lobby", _message, socket) do
    Process.send_after(self(), :notify_state, 50)
    {:ok, socket}
  end

  def handle_in("add", %{}, socket) do
    Weblica.GenServer.add()
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_in("remove", %{}, socket) do
    Weblica.GenServer.remove()
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_in("crash", %{}, socket) do
    Weblica.GenServer.crash()
    Process.send_after(self(), :notify_state, 50)
    {:noreply, socket}
  end

  def handle_info(:notify_state, socket) do
    notify_state(socket)
    {:noreply, socket}
  end

  defp notify_state(socket) do
    socket |> broadcast!("status", %{tokens: Weblica.GenServer.list()})
  end
end

defmodule WeblicaWeb.GenServerChannel do
  use Phoenix.Channel

  def join("genServer:lobby", _message, socket) do
    Process.send_after(self(), :notify_state, 50)
    {:ok, socket}
  end

  def handle_in("feed", %{}, socket) do
    Weblica.GenServer.feed()
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_in("eat", %{}, socket) do
    Weblica.GenServer.eat()
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_in("punch", %{}, socket) do
    Weblica.GenServer.punch()
    Process.send_after(self(), :notify_state, 50)
    {:noreply, socket}
  end

  def handle_info(:notify_state, socket) do
    notify_state(socket)
    {:noreply, socket}
  end

  defp notify_state(socket) do
    socket |> broadcast!("stomach", %{stomach: Weblica.GenServer.list()})
  end
end

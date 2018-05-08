defmodule WeblicaWeb.SupervisorChannel do
  use Phoenix.Channel

  def join("supervisor:lobby", _message, socket) do
    Process.send_after(self(), :notify_state, 50)
    {:ok, socket}
  end

  def handle_in("feed", %{}, socket) do
    Weblica.ETSGenServer.feed()
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_in("eat", %{}, socket) do
    Weblica.ETSGenServer.eat()
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_in("punch", %{}, socket) do
    Weblica.ETSGenServer.punch()
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_info(:notify_state, socket) do
    notify_state(socket)

    {:noreply, socket}
  end

  defp notify_state(socket) do
    socket |> broadcast!("stomach", %{stomach: Weblica.ETSGenServer.list()})
  end
end

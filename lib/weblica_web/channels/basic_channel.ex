defmodule WeblicaWeb.BasicChannel do
  use Phoenix.Channel

  def join("basic:lobby", _message, socket) do
    Process.send_after(self(), :notify_state, 50)
    {:ok, socket}
  end

  def handle_in("feed", %{}, socket) do
    get_worker() |> send(:feed)
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_in("eat", %{}, socket) do
    get_worker() |> send(:eat)
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  def handle_in("punch", %{}, socket) do
    get_worker() |> send(:punch)
    Process.send_after(self(), :notify_state, 50)

    {:noreply, socket}
  end

  defp get_worker() do
    {_name, worker_pid, :worker, _opts} =
      Weblica.Supervisor
      |> Supervisor.which_children()
      |> Enum.find(fn {module, _pid, _type, _opts} -> module == Weblica.Basic end)

    worker_pid
  end

  defp get_worker_state() do
    get_worker() |> send({:list, self()})

    receive do
      {:ok, list} -> list
    end
  end

  def handle_info(:notify_state, socket) do
    notify_state(socket)
    {:noreply, socket}
  end

  defp notify_state(socket) do
    socket |> broadcast!("stomach", %{stomach: get_worker_state()})
  end
end

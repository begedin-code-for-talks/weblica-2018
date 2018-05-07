defmodule WeblicaWeb.BasicChannel do
  use Phoenix.Channel

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

  def join("basic:lobby", _message, socket) do
    {:ok, get_worker_state(), socket}
  end

  def handle_in("shorten", %{"body" => body}, socket) do
    get_worker() |> send({:shorten, body})

    socket |> broadcast!("state", get_worker_state())

    {:noreply, socket}
  end
end

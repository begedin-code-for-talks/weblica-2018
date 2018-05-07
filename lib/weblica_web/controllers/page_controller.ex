defmodule WeblicaWeb.PageController do
  use WeblicaWeb, :controller

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
      {:ok, list} -> list |> IO.inspect
    end
  end

  def index(conn, _params) do
    render conn, "index.html"
  end

  def redirector(conn, %{"shortened_url" => shortened_url}) do
    case get_worker_state() |> Enum.find(fn {_key, value} -> value == shortened_url end) do
      nil ->
        conn |> put_flash(:info, "Url not found")|> redirect(to: conn |> page_path(:index))

      {external_url, _shortened} ->
        conn |> redirect(external: external_url) |> IO.inspect()
    end
  end
end

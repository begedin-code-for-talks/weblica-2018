defmodule WeblicaWeb.SupervisorChannel do
  use Phoenix.Channel

  def join("supervisor:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("shorten", %{"body" => body}, socket) do
    socket |> broadcast!("shortened", %{body: body})
    {:noreply, socket}
  end
end

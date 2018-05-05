defmodule WeblicaWeb.PageController do
  use WeblicaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

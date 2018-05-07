defmodule WeblicaWeb.Router do
  use WeblicaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WeblicaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/:shortened_url", PageController, :redirector
  end
end

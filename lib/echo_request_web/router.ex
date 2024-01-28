defmodule EchoRequestWeb.Router do
  use EchoRequestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EchoRequestWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EchoRequestWeb do
    pipe_through :browser

    get "/request/:token", PageController, :request

    live_session :request do
      live "/", RequestLive.Index, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", EchoRequestWeb do
  #   pipe_through :api
  # end
end

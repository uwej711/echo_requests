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

  pipeline :request do
    plug :fetch_session
  end

  scope "/", EchoRequestWeb do
    pipe_through :browser

    live_session :request do
      live "/", RequestLive.Index, :index
    end
  end

  scope "/request", EchoRequestWeb do
    pipe_through :request

    match :*, "/:token", PageController, :request
  end
end

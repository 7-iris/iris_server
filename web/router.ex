defmodule Iris.Router do
  use Iris.Web, :router

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

  scope "/", Iris do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController

  end

  scope "/api", Iris do
     pipe_through :api

    resources "/services", ServiceController, except: [:new, :edit]
    resources "/messages", MessageController
  end
end

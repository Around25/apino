defmodule ApinoWeb.Router do
  use ApinoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApinoWeb do
    pipe_through :api
    resources "/entities", EntityController, except: [:new, :edit]
    resources "/properties", PropertyController, except: [:new, :edit]
  end
end

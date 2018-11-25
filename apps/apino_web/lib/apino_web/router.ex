defmodule ApinoWeb.Router do
  use ApinoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApinoWeb do
    pipe_through :api

    # manage entities
    resources "/entities", EntityController, except: [:new, :edit]
    # manage properties
    resources "/properties", PropertyController, except: [:new, :edit]
    # manage publish
    post "/publish", DeployController, :publish
  end
end

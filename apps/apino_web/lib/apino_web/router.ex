defmodule ApinoWeb.Router do
  use ApinoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApinoWeb do
    pipe_through :api
  end
end

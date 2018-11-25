defmodule ApinoWeb.DeployController do
  use ApinoWeb, :controller

  action_fallback ApinoWeb.FallbackController

  @doc """
  Publish the changes made to the entities and their properties and update
  the generated files in the app/app_web folders
  """
  def publish(conn, _params) do
    Apino.Generator.CreateApp.deploy(:fresh)
    send_resp(conn, :no_content, "")
  end

end

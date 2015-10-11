defmodule ChatPhoenix.PageController do
  use ChatPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

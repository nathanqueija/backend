defmodule ReWeb.NeighborhoodController do
  use ReWeb, :controller

  alias Re.Neighborhoods

  def index(conn, _params) do
    render(conn, "index.json", neighborhoods: Neighborhoods.all())
  end
end

defmodule Re.Images.Policy do
  @moduledoc """
  Policy module for user permission on images
  """

  def authorize(_, %{role: "admin"}, _), do: :ok
  def authorize(_, nil, _), do: {:error, :unauthorized}
  def authorize(_, _, _), do: {:error, :forbidden}

end
defmodule Re.Listings.Filters.Relax do
  @moduledoc """
  Module to group logic to relax filter parameters
  """

  alias Re.Listings.Filter

  defguardp is_not_nil(value) when not is_nil(value)

  def apply(params, types) when is_list(types) do
    Enum.reduce(types, params, &do_apply/2)
  end

  def apply(params, _), do: params

  def do_apply(:price, params) do
    params
    |> Filter.cast()
    |> max_price()
    |> min_price()
  end

  def do_apply(:area, params) do
    params
    |> Filter.cast()
    |> max_area()
    |> min_area()
  end

  def do_apply(_, params), do: params

  defp max_price(%{max_price: max_price} = params) when is_not_nil(max_price) do
    Map.update(params, :max_price, 0, &trunc(&1 * 1.1))
  end

  defp max_price(params), do: params

  defp min_price(%{min_price: min_price} = params) when is_not_nil(min_price) do
    Map.update(params, :min_price, 0, &trunc(&1 * 0.9))
  end

  defp min_price(params), do: params

  defp max_area(%{max_area: max_area} = params) when is_not_nil(max_area) do
    Map.update(params, :max_area, 0, &trunc(&1 * 1.1))
  end

  defp max_area(params), do: params

  defp min_area(%{min_area: min_area} = params) when is_not_nil(min_area) do
    Map.update(params, :min_area, 0, &trunc(&1 * 0.9))
  end

  defp min_area(params), do: params
end

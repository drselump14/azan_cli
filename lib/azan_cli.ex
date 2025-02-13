defmodule AzanCli do
  @moduledoc """
  Documentation for `AzanCli`.
  """

  def start(_, _) do
    System.halt(0)
  end

  def build_coordinate(latitude, longitude) do
    date = Timex.today(:local)
    params = Azan.CalculationMethod.muslim_world_league()
    {:ok, coordinate} = Azan.Coordinate.new(latitude: latitude, longitude: longitude)
  end
end

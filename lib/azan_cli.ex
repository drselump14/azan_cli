defmodule AzanCli do
  @moduledoc """
  Documentation for `AzanCli`.
  """

  alias Azan.CalculationMethod
  alias Azan.Coordinate
  alias Azan.PrayerTime

  def start(_, _) do
    {args, _, _} =
      Burrito.Util.Args.argv() |> OptionParser.parse(strict: [lat: :float, lng: :float])

    latitude = args[:lat]
    longitude = args[:lng]

    date = Timex.today(:local)
    params = CalculationMethod.muslim_world_league()
    {:ok, coordinate} = Coordinate.new(latitude: latitude, longitude: longitude)

    prayer_time = coordinate |> PrayerTime.find(date, params)
    current_prayer = prayer_time |> PrayerTime.current_prayer(Timex.now())

    {prayer_time, next_prayer} =
      if current_prayer == :isha do
        tomorrow = Timex.shift(date, days: 1)
        {coordinate |> PrayerTime.find(tomorrow, params), :fajr}
      else
        {prayer_time, prayer_time |> PrayerTime.next_prayer(Timex.now())}
      end

    next_prayer_time =
      prayer_time
      |> PrayerTime.time_for_prayer(next_prayer)

    local_next_prayer_time = next_prayer_time |> Timex.local() |> Timex.format!("{h24}:{m}")

    remaining_total = Timex.diff(next_prayer_time, Timex.now(), :minutes)
    remaining_hours = div(remaining_total, 60)
    remaining_minutes = rem(remaining_total, 60)

    local_prayer_time =
      prayer_time
      |> Map.from_struct()
      |> Map.new(fn {prayer_name, time} ->
        {
          prayer_name,
          time |> Timex.local() |> Timex.format!("{h24}:{m}")
        }
      end)

    %{
      "next_prayer" => next_prayer |> Atom.to_string() |> String.upcase(),
      "next_prayer_time" => local_next_prayer_time,
      "remaining_total" => remaining_total,
      "remaining_hours" => remaining_hours,
      "remaining_minutes" => remaining_minutes,
      "prayer_time" => local_prayer_time
    }
    |> Jason.encode!()
    |> IO.puts()

    System.halt(0)
  end
end

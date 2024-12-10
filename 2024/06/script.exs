defmodule Day06 do
  def parse(input) do
    map =
      for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
          {char, x} <- Enum.with_index(to_charlist(line)),
          into: %{} do
        {{x, y}, char}
      end

    guard = Enum.find(map, fn {_key, val} -> val == ?^ end) |> elem(0)

    # {map, guard, direction, turns}
    {map, guard, :up, %{}}
  end

  # For printing
  def guard_char(:up) do
    ?^
  end

  def guard_char(:right) do
    ?>
  end

  def guard_char(:down) do
    ?v
  end

  def guard_char(:left) do
    ?<
  end

  def rotate(:up) do
    :right
  end

  def rotate(:right) do
    :down
  end

  def rotate(:down) do
    :left
  end

  def rotate(:left) do
    :up
  end

  def step(map, {x, y} = guard, direction, turns) do
    key =
      case direction do
        :up -> {x, y - 1}
        :down -> {x, y + 1}
        :left -> {x - 1, y}
        :right -> {x + 1, y}
      end

    case Map.get(map, key) do
      nil ->
        map = %{map | guard => ?X}
        guard = nil
        {map, guard, direction, turns}

      ?. ->
        map = %{map | guard => ?X}
        map = %{map | key => guard_char(direction)}
        guard = key
        {map, guard, direction, turns}

      ?X ->
        map = %{map | guard => ?X}
        map = %{map | key => guard_char(direction)}
        guard = key
        {map, guard, direction, turns}

      ?# ->
        direction = rotate(direction)

        case Map.get(turns, guard) do
          nil ->
            {map, guard, direction, Map.put(turns, guard, [direction])}

          list ->
            case Enum.member?(list, direction) do
              true ->
                :halt

              false ->
                {map, guard, direction, %{turns | guard => list ++ [direction]}}
            end
        end
    end
  end

  def solve_1(map, guard, direction, turns) do
    {new_map, new_guard, new_direction, new_turns} =
      step(map, guard, direction, turns)

    case new_guard do
      nil -> {new_map, new_guard, new_direction, new_turns}
      _ -> solve_1(new_map, new_guard, new_direction, new_turns)
    end
  end

  def solve_2(map, guard, direction, turns) do
    case step(map, guard, direction, turns) do
      :halt ->
        1

      {new_map, new_guard, new_direction, new_turns} ->
        case new_guard do
          nil -> 0
          _ -> solve_2(new_map, new_guard, new_direction, new_turns)
        end
    end
  end

  def part_1({map, guard, direction, turns}) do
    {new_map, _, _, _} = solve_1(map, guard, direction, turns)
    Enum.filter(new_map, &(elem(&1, 1) == ?X)) |> Enum.count()
  end

  def part_2({map, guard, direction, turns}) do
    {new_map, _, _, _} = solve_1(map, guard, direction, turns)

    new_map
    |> Enum.filter(&(elem(&1, 0) != guard and elem(&1, 1) == ?X))
    |> Enum.map(&solve_2(%{map | elem(&1, 0) => ?#}, guard, direction, turns))
    |> Enum.sum()
  end
end

input = "./input" |> File.read!() |> Day06.parse()
# input |> Day06.part_1() |> IO.inspect()
input |> Day06.part_2() |> IO.inspect()

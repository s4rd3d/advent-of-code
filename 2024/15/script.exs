defmodule Day15 do
  def parse(input, part) do
    duplicate_fun = fn
      ?#, :part2 -> [?#, ?#]
      ?., :part2 -> [?., ?.]
      ?O, :part2 -> [?[, ?]]
      ?@, :part2 -> [?@, ?.]
      char, _ -> char
    end

    [map_raw, moves] = input |> String.split("\n\n", trim: true)

    map =
      for {line, y} <- Enum.with_index(String.split(map_raw, "\n", trim: true)),
          {char, x} <-
            Enum.with_index(
              to_charlist(line)
              |> Enum.map(&duplicate_fun.(&1, part))
              |> List.flatten()
            ),
          into: %{} do
        {{x, y}, char}
      end

    {map, moves |> String.to_charlist() |> Enum.reject(&(&1 == ?\n))}
  end

  def part_1({map, moves}) do
    solve(map, moves) |> gps(:part1)
  end

  def part_2({map, moves}) do
    solve(map, moves) |> gps(:part2)
  end

  def solve(map, moves) do
    {start_position, ?@} = Enum.find(map, &(elem(&1, 1) == ?@))

    {_result_position, result_map} =
      Enum.reduce(
        moves,
        {start_position, map},
        fn move, {acc_position, acc_map} ->
          to = to(acc_position, move)

          try do
            {:ok, new_map} = try_move(acc_position, to, acc_map)

            case Map.get(new_map, to) do
              ?@ ->
                {to, new_map}

              _other ->
                {acc_position, new_map}
            end
          catch
            :wall ->
              {acc_position, acc_map}
          end
        end
      )

    result_map
  end

  def try_move(from, to, map) do
    direction = vec(from, to)

    case Map.get(map, to) do
      ?. ->
        move(from, to, map)

      ?# ->
        throw(:wall)

      ?O ->
        try_push(from, to, map)

      char when (char == ?] or char == ?[) and elem(direction, 1) == 0 ->
        try_push(from, to, map)

      ?[ ->
        try_push_vertical(from, to, {1, 0}, map)

      ?] ->
        try_push_vertical(from, to, {-1, 0}, map)
    end
  end

  def try_push(from, to, map) do
    {:ok, new_map} = try_move(to, next(from, to), map)
    move(from, to, new_map)
  end

  def try_push_vertical(from, to, offset, map) do
    {:ok, new_map} = try_move(to, next(from, to), map)

    {:ok, new_map} =
      try_move(add(to, offset), add(next(from, to), offset), new_map)

    move(from, to, new_map)
  end

  def move(from, to, map) do
    {:ok, %{map | to => Map.get(map, from), from => ?.}}
  end

  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def vec({x1, y1} = _from, {x2, y2} = _to) do
    {x2 - x1, y2 - y1}
  end

  def next({x1, y1} = _from, {x2, y2} = _to) do
    {x2 + x2 - x1, y2 + y2 - y1}
  end

  def to({x, y} = _from, ?^), do: {x, y - 1}
  def to({x, y} = _from, ?>), do: {x + 1, y}
  def to({x, y} = _from, ?<), do: {x - 1, y}
  def to({x, y} = _from, ?v), do: {x, y + 1}

  def print(map) do
    width = map |> Enum.filter(&(elem(elem(&1, 0), 1) == 0)) |> Enum.count()
    height = map |> Enum.filter(&(elem(elem(&1, 0), 0) == 0)) |> Enum.count()

    for y <- 0..(height - 1) do
      for x <- 0..(width - 1) do
        char = Map.get(map, {x, y})
        IO.write([char])
      end

      IO.write("\n")
    end

    :ok
  end

  def gps(map, part) do
    map
    |> Enum.filter(
      &((part == :part1 and elem(&1, 1) == ?O) or
          (part == :part2 and elem(&1, 1) == ?[))
    )
    |> Enum.map(&(elem(elem(&1, 0), 1) * 100 + elem(elem(&1, 0), 0)))
    |> Enum.sum()
  end
end

input1 = "./input" |> File.read!() |> Day15.parse(:part1)
input2 = "./input" |> File.read!() |> Day15.parse(:part2)
input1 |> Day15.part_1() |> IO.inspect()
input2 |> Day15.part_2() |> IO.inspect()

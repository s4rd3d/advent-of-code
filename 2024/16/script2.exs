Mix.install([
  :libgraph
])

defmodule Day16 do
  @directions %{
    north: {0, -1},
    east: {1, 0},
    south: {0, 1},
    west: {-1, 0}
  }

  @rotate_cw %{north: :east, east: :south, south: :west, west: :north}

  def parse(input) do
    map =
      for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
          {char, x} <- Enum.with_index(to_charlist(line)),
          into: %{} do
        {{x, y}, char}
      end

    edges =
      for {{x, y}, char} <- map do
        if char != ?# do
          generate_edges(x, y, map)
        end
      end
      |> List.flatten()
      |> Enum.reject(&is_nil/1)

    {Graph.new() |> Graph.add_edges(edges), map}
  end

  def generate_edges(x, y, map) do
    self_edges =
      for {dir1, dir2} <- @rotate_cw do
        [
          Graph.Edge.new(
            {x, y, dir1},
            {x, y, dir2},
            weight: 1000
          ),
          Graph.Edge.new(
            {x, y, dir2},
            {x, y, dir1},
            weight: 1000
          )
        ]
      end
      |> List.flatten()

    out_edges =
      for {dir, {dx, dy}} <- @directions do
        if Map.get(map, {x + dx, y + dy}) != ?# do
          Graph.Edge.new(
            {x, y, dir},
            {x + dx, y + dy, dir},
            weight: 1
          )
        end
      end

    self_edges ++ out_edges
  end

  def part_1({graph, map}) do
    {s_x, s_y} =
      Enum.filter(map, &(elem(&1, 1) == ?S))
      |> hd()
      |> elem(0)

    {e_x, e_y} =
      Enum.filter(map, &(elem(&1, 1) == ?E))
      |> hd()
      |> elem(0)

    Graph.dijkstra(graph, {s_x, s_y, :east}, {e_x, e_y, :north}) |> score
  end

  def score(path), do: score(path, 0)

  def score([_last], acc), do: acc

  def score([{_, _, dir} = _current, {_, _, dir} = next | rest], acc) do
    score([next | rest], acc + 1)
  end

  def score([{x, y, _dir1} = _current, {x, y, _dir2} = next | rest], acc) do
    score([next | rest], acc + 1000)
  end
end

input = "./input" |> File.read!() |> Day16.parse()
input |> Day16.part_1() |> IO.inspect(limit: :infinity)

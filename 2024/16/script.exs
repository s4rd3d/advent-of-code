Mix.install([
  {:priority_queue, "~> 1.0"}
])

defmodule Day16 do
  @directions %{
    north: {0, -1},
    east: {1, 0},
    south: {0, 1},
    west: {-1, 0}
  }

  @rotate_cw %{north: :east, east: :south, south: :west, west: :north}
  @rotate_ccw %{north: :west, west: :south, south: :east, east: :north}

  def parse(input) do
    for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {char, x} <- Enum.with_index(to_charlist(line)),
        into: %{} do
      {{x, y}, char}
    end
  end

  def part_1(input) do
    s = Enum.find(input, &(elem(&1, 1) == ?S)) |> elem(0)
    e = Enum.find(input, &(elem(&1, 1) == ?E)) |> elem(0)
    pq = PriorityQueue.new() |> PriorityQueue.put(0, {s, :east})
    visited = MapSet.new()
    dijkstra(PriorityQueue.pop(pq), e, visited, input)
  end

  def dijkstra({{:empty, nil}, _pq}, _e, _visited, _map) do
    # No path found between s and e
    :infinity
  end

  def dijkstra({{cost, {{x, y}, direction}}, pq}, e, visited, map) do
    if MapSet.member?(visited, {x, y, direction}) do
      dijkstra(PriorityQueue.pop(pq), e, visited, map)
    else
      visited = MapSet.put(visited, {x, y, direction})

      if {x, y} == e do
        cost
      else
        neighbors = neighbors(map, {x, y}, direction)

        new_states =
          Enum.map(neighbors, fn
            {:move, {nx, ny}} ->
              {cost + 1, {{nx, ny}, direction}}

            {:rotate, :cw} ->
              {cost + 1000, {{x, y}, Map.get(@rotate_cw, direction)}}

            {:rotate, :ccw} ->
              {cost + 1000, {{x, y}, Map.get(@rotate_ccw, direction)}}
          end)

        pq = Enum.reduce(new_states, pq, &PriorityQueue.put(&2, &1))
        dijkstra(PriorityQueue.pop(pq), e, visited, map)
      end
    end
  end

  def neighbors(map, {x, y}, direction) do
    {dx, dy} = Map.get(@directions, direction)
    forward = {x + dx, y + dy}

    moves =
      if passable?(map, forward) do
        [{:move, forward}]
      else
        []
      end

    moves ++ [{:rotate, :cw}, {:rotate, :ccw}]
  end

  def passable?(map, {x, y}) do
    width = map |> Enum.filter(&(elem(elem(&1, 0), 1) == 0)) |> Enum.count()
    height = map |> Enum.filter(&(elem(elem(&1, 0), 0) == 0)) |> Enum.count()
    y >= 0 and y < height and x >= 0 and x < width and Map.get(map, {x, y}) != ?#
  end

  def part_2(input) do
    input
  end
end

input = "./input_small" |> File.read!() |> Day16.parse()
input |> Day16.part_1() |> IO.inspect()
# input |> Day16.part_2() |> IO.inspect()

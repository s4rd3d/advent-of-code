Mix.install([
  :libgraph
])

defmodule Day10 do
  def parse(input) do
    split = String.split(input, "\n", trim: true)

    map =
      for {line, y} <- Enum.with_index(split),
          {level, x} <- Enum.with_index(to_charlist(line)),
          into: %{} do
        {{x, y}, level}
      end

    rows = length(split) - 1
    cols = length(String.to_charlist(hd(split))) - 1

    edges =
      for {dx, dy} <- [{1, 0}, {0, 1}], x <- 0..cols, y <- 0..rows do
        cond do
          x + dx <= cols and y + dy <= rows and
              Map.get(map, {x + dx, y + dy}) - Map.get(map, {x, y}) == 1 ->
            Graph.Edge.new(
              {x, y, Map.get(map, {x, y})},
              {x + dx, y + dy, Map.get(map, {x + dx, y + dy})}
            )

          x + dx <= cols and y + dy <= rows and
              Map.get(map, {x, y}) - Map.get(map, {x + dx, y + dy}) == 1 ->
            Graph.Edge.new(
              {x + dx, y + dy, Map.get(map, {x + dx, y + dy})},
              {x, y, Map.get(map, {x, y})}
            )

          true ->
            nil
        end
      end
      |> Enum.reject(&is_nil/1)

    Graph.new() |> Graph.add_edges(edges)
  end

  def part_1(input) do
    Graph.vertices(input)
    |> Enum.filter(&(elem(&1, 2) == ?0))
    |> Enum.reduce(
      0,
      fn vertex, acc ->
        acc +
          (Graph.reachable(input, [vertex])
           |> Enum.filter(&(elem(&1, 2) == ?9))
           |> Enum.count())
      end
    )
  end

  def part_2(input) do
    end_vertices = Graph.vertices(input) |> Enum.filter(&(elem(&1, 2) == ?9))

    Graph.vertices(input)
    |> Enum.filter(&(elem(&1, 2) == ?0))
    |> Enum.reduce(
      0,
      fn start_vertex, acc ->
        acc +
          Enum.reduce(
            end_vertices,
            0,
            &(&2 + (Graph.get_paths(input, start_vertex, &1) |> Enum.count()))
          )
      end
    )
  end
end

input = "./input" |> File.read!() |> Day10.parse()
input |> Day10.part_1() |> IO.inspect()
input |> Day10.part_2() |> IO.inspect()

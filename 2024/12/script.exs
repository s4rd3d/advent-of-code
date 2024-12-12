Mix.install([
  :libgraph
])

defmodule Day12 do
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
              Map.get(map, {x + dx, y + dy}) == Map.get(map, {x, y}) ->
            Graph.Edge.new(
              {x, y, Map.get(map, {x, y})},
              {x + dx, y + dy, Map.get(map, {x + dx, y + dy})}
            )

          true ->
            nil
        end
      end
      |> Enum.reject(&is_nil/1)

    # We need to add vertices in case we missed single components when adding
    # edges.
    Graph.new(type: :undirected)
    |> Graph.add_edges(edges)
    |> Graph.add_vertices(
      Enum.to_list(map)
      |> Enum.map(fn {{x, y}, val} -> {x, y, val} end)
    )
  end

  def part_1(input) do
    input
    |> Graph.components()
    |> Enum.map(&Graph.subgraph(input, &1))
    |> Enum.reduce(0, &(&2 + price(&1)))
  end

  def part_2(input) do
    input
  end

  def price(graph) do
    area = Graph.num_vertices(graph)
    perimeter = area * 4 - Graph.num_edges(graph) * 2
    area * perimeter
  end
end

input = "./input" |> File.read!() |> Day12.parse()
input |> Day12.part_1() |> IO.inspect()
# input |> Day12.part_2() |> IO.inspect()

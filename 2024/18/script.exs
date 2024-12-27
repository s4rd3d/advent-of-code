Mix.install([
  :libgraph
])

defmodule Day18 do
  def parse(input) do
    width = 71
    height = 71

    edges =
      for y <- 0..(height - 1),
          x <- 0..(width - 1) do
        [
          if x + 1 < width do
            Graph.Edge.new({x, y}, {x + 1, y})
          end,
          if x - 1 >= 0 do
            Graph.Edge.new({x, y}, {x - 1, y})
          end,
          if y + 1 < height do
            Graph.Edge.new({x, y}, {x, y + 1})
          end,
          if y - 1 >= 0 do
            Graph.Edge.new({x, y}, {x, y - 1})
          end
        ]
      end
      |> List.flatten()
      |> Enum.reject(&(&1 == nil))

    bytes =
      for line <- String.split(input, "\n") do
        [x, y] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
        {x, y}
      end

    {Graph.new() |> Graph.add_edges(edges), width, height, bytes}
  end

  def part_1({grid, w, h, bytes}) do
    grid = Graph.delete_vertices(grid, Enum.slice(bytes, 0..1023))
    (Graph.get_shortest_path(grid, {0, 0}, {w - 1, h - 1}) |> Enum.count()) - 1
  end

  def part_2({grid, w, h, bytes}) do
    # Did a manual binary search here, maybe implement automatic later
    grid = Graph.delete_vertices(grid, Enum.slice(bytes, 0..2907))
    Graph.reachable(grid, [{0, 0}]) |> Enum.member?({w - 1, h - 1})
    # Enum.slice(bytes, 2907..2907)
  end
end

input = "./input" |> File.read!() |> Day18.parse()
input |> Day18.part_1() |> IO.inspect()
input |> Day18.part_2() |> IO.inspect()

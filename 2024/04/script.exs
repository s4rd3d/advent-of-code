defmodule Day04 do
  def parse(input) do
    for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {char, x} <- Enum.with_index(to_charlist(line)),
        into: %{} do
      {{x, y}, char}
    end
  end

  def part_1(input) do
    for {{x, y}, ?X} <- input do
      directions = [
        [{x, y - 1}, {x, y - 2}, {x, y - 3}],
        [{x, y + 1}, {x, y + 2}, {x, y + 3}],
        [{x - 1, y}, {x - 2, y}, {x - 3, y}],
        [{x + 1, y}, {x + 2, y}, {x + 3, y}],
        [{x - 1, y - 1}, {x - 2, y - 2}, {x - 3, y - 3}],
        [{x - 1, y + 1}, {x - 2, y + 2}, {x - 3, y + 3}],
        [{x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3}],
        [{x + 1, y - 1}, {x + 2, y - 2}, {x + 3, y - 3}]
      ]

      Enum.count(directions, fn direction ->
        Enum.map(direction, &input[&1]) == ~c"MAS"
      end)
    end
    |> Enum.sum()
  end

  def part_2(input) do
    for {{x, y}, ?A} <- input do
      directions = [
        [{x - 1, y + 1}, {x + 1, y + 1}, {x + 1, y - 1}, {x - 1, y - 1}],
        [{x - 1, y - 1}, {x - 1, y + 1}, {x + 1, y + 1}, {x + 1, y - 1}],
        [{x + 1, y - 1}, {x - 1, y - 1}, {x - 1, y + 1}, {x + 1, y + 1}],
        [{x + 1, y + 1}, {x + 1, y - 1}, {x - 1, y - 1}, {x - 1, y + 1}],
      ]

      Enum.count(directions, fn direction ->
        Enum.map(direction, &input[&1]) == ~c"MMSS"
      end)
    end
    |> Enum.sum()
  end
end

input = "./input" |> File.read!() |> Day04.parse()
input |> Day04.part_1() |> IO.inspect()
input |> Day04.part_2() |> IO.inspect()

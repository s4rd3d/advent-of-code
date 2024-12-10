defmodule Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> List.foldl(
      {[], []},
      fn line, {l1, l2} ->
        [first, second] = String.split(line) |> Enum.map(&String.to_integer/1)
        {[first | l1], [second | l2]}
      end
    )
  end

  def part_1({left, right}) do
    Enum.zip_reduce(Enum.sort(left), Enum.sort(right), 0, &(&3 + abs(&1 - &2)))
  end

  def part_2({left, right}) do
    freq = Enum.frequencies(right)
    left |> Enum.reduce(0, &(&2 + &1 * Map.get(freq, &1, 0)))
  end
end

input = "./input" |> File.read!() |> Day01.parse()
input |> Day01.part_1() |> IO.puts()
input |> Day01.part_2() |> IO.puts()

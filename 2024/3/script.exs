defmodule Day03 do
  def parse(input) do
    input
  end

  def part_1(input) do
    ~r/mul\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(input, capture: :all_but_first)
    |> Enum.map(fn line ->
      line
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> String.replace(~r/don't\(\)[\s\S]+?(do\(\)|$)/, "")
    |> part_1()
  end

end

input = "./input" |> File.read!() |> Day03.parse()
input |> Day03.part_1() |> IO.inspect()
input |> Day03.part_2() |> IO.inspect()

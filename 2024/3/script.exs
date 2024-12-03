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
      |> Enum.reduce(1, &(&1 * &2))
    end)
    |> Enum.sum()
  end

  def part_2(input) do
    ~r/mul\((\d{1,3}),(\d{1,3})\)|(do\(\))|(don't\(\))/
    |> Regex.scan(input, capture: :all_but_first)
    |> Enum.map(fn line ->
      line
      |> Enum.filter(&(&1 != ""))
    end)
    |> Enum.reduce(
      {:enabled, 0},
      fn
        ["don't()"], {_, acc} ->
          {:disabled, acc}

        ["do()"], {_, acc} ->
          {:enabled, acc}

        [e1, e2], {:enabled, acc} ->
          {:enabled, acc + String.to_integer(e1) * String.to_integer(e2)}

        _, {:disabled, acc} ->
          {:disabled, acc}
      end
    )
    |> elem(1)
  end

end

input = "./input" |> File.read!() |> Day03.parse()
input |> Day03.part_1() |> IO.inspect()
input |> Day03.part_2() |> IO.inspect()

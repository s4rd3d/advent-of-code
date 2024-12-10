defmodule Day05 do
  def parse(input) do
    [rules, lines] = String.split(input, "\n\n", trim: true)

    rules_map =
      rules
      |> String.split("\n")
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.reduce(
        %{},
        fn [first, second], acc ->
          key = String.to_integer(first)
          value = String.to_integer(second)
          Map.update(acc, key, [value], &(&1 ++ [value]))
        end
      )

    {rules_map,
     lines
     |> String.split("\n", trim: true)
     |> Enum.map(fn line ->
       String.split(line, ",")
       |> Enum.map(&String.to_integer/1)
     end)}
  end

  def part_1({rules, paths}) do
    paths
    |> Enum.filter(&correct_order?(&1, rules))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  def part_2({rules, paths}) do
    paths
    |> Enum.filter(&(!correct_order?(&1, rules)))
    |> Enum.map(&correct_order(&1, rules))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  def correct_order?([_last], _rules) do
    true
  end

  def correct_order?([head, next | rest], rules) do
    case Map.get(rules, head) do
      nil ->
        false

      list ->
        case Enum.member?(list, next) do
          true -> correct_order?([next | rest], rules)
          false -> false
        end
    end
  end

  def correct_order(path, rules) do
    new_order = correct_order(path, rules, [])
    case correct_order?(new_order, rules) do
      true -> new_order
      false -> correct_order(new_order, rules)
    end
  end

  def correct_order([last], _rules, acc) do
    acc ++ [last]
  end

  def correct_order([head, next | rest], rules, acc) do
    case Map.get(rules, head) do
      nil ->
        correct_order([head | rest], rules, acc ++ [next])

      list ->
        case Enum.member?(list, next) do
          true -> correct_order([next | rest], rules, acc ++ [head])
          false -> correct_order([head | rest], rules, acc ++ [next])
        end
    end
  end
end

input = "./input" |> File.read!() |> Day05.parse()
input |> Day05.part_1() |> IO.inspect()
input |> Day05.part_2() |> IO.inspect()

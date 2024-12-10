defmodule Day07 do
  def parse(input) do
    for line <- String.split(input, "\n", trim: true) do
      [test_value, numbers] = String.split(line, ":", trim: true)

      {
        String.to_integer(test_value),
        String.split(numbers) |> Enum.map(&String.to_integer/1)
      }
    end
  end

  def part_1(input) do
    input
    |> Enum.filter(&solve_equation(elem(&1, 0), elem(&1, 1), ["+", "*"]))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> Enum.filter(&solve_equation(elem(&1, 0), elem(&1, 1), ["+", "*", "|"]))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def solve_equation(test_value, list, operators) do
    tree = build_tree(list, operators)

    try do
      _result = traverse(tree, test_value)
      false
    catch
      :halt -> true
    end
  end

  def build_tree([root | rest], operators) do
    build_tree({root, "+"}, rest, operators)
  end

  def build_tree({current, label}, [], _operators) do
    {current, label, nil}
  end

  def build_tree({current, label}, [h | rest], operators) do
    {
      current,
      label,
      for operator <- operators do
        build_tree({h, operator}, rest, operators)
      end
    }
  end

  def traverse(tree, test_value) do
    traverse(tree, test_value, 0)
  end

  def traverse({current, operator, nil}, test_value, acc) do
    case apply_operator(acc, current, operator) do
      ^test_value -> throw(:halt)
      other -> other
    end
  end

  def traverse({current, operator, children}, test_value, acc) do
    for child <- children do
      traverse(child, test_value, apply_operator(acc, current, operator))
    end
  end

  def apply_operator(left, right, "+"), do: left + right
  def apply_operator(left, right, "*"), do: left * right

  def apply_operator(left, right, "|") do
    (Integer.to_string(left) <> Integer.to_string(right)) |> String.to_integer()
  end
end

input = "./input" |> File.read!() |> Day07.parse()
input |> Day07.part_1() |> IO.inspect()
input |> Day07.part_2() |> IO.inspect()

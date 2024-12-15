defmodule Day13 do
  def parse1(input) do
    pattern =
      ~r/Button A: X\+(?<a_x>\d+), Y\+(?<a_y>\d+)\nButton B: X\+(?<b_x>\d+), Y\+(?<b_y>\d+)\nPrize: X=(?<x>\d+), Y=(?<y>\d+)/

    input
    |> String.split("\n\n")
    |> Enum.map(fn line ->
      map = Regex.named_captures(pattern, line)
      a_x = String.to_integer(Map.get(map, "a_x"))
      b_x = String.to_integer(Map.get(map, "b_x"))
      x = String.to_integer(Map.get(map, "x"))
      a_y = String.to_integer(Map.get(map, "a_y"))
      b_y = String.to_integer(Map.get(map, "b_y"))
      y = String.to_integer(Map.get(map, "y"))
      c1 = fn a, b -> a_x * a + b_x * b == x end
      c2 = fn a, b -> a_y * a + b_y * b == y end
      {c1, c2}
    end)
  end

  def parse2(input) do
    pattern =
      ~r/Button A: X\+(?<a_x>\d+), Y\+(?<a_y>\d+)\nButton B: X\+(?<b_x>\d+), Y\+(?<b_y>\d+)\nPrize: X=(?<x>\d+), Y=(?<y>\d+)/

    input
    |> String.split("\n\n")
    |> Enum.map(fn line ->
      map = Regex.named_captures(pattern, line)
      a_x = String.to_integer(Map.get(map, "a_x"))
      b_x = String.to_integer(Map.get(map, "b_x"))
      x = String.to_integer(Map.get(map, "x"))
      a_y = String.to_integer(Map.get(map, "a_y"))
      b_y = String.to_integer(Map.get(map, "b_y"))
      y = String.to_integer(Map.get(map, "y"))

      %{
        a_x: a_x,
        b_x: b_x,
        a_y: a_y,
        b_y: b_y,
        x: x + 10_000_000_000_000,
        y: y + 10_000_000_000_000
      }
    end)
  end

  def minimize_expression(constraint1, constraint2) do
    # Define the objective function
    objective = fn a, b -> 3 * a + b end

    # Search for valid (a, b) pairs
    grid = for a <- 0..100, b <- 0..100, do: {a, b}

    valid_solutions =
      Enum.filter(grid, fn {a, b} ->
        constraint1.(a, b) and constraint2.(a, b)
      end)

    # Minimize the objective function over valid solutions
    case valid_solutions do
      [] ->
        0

      _ ->
        Enum.min_by(valid_solutions, fn {a, b} -> objective.(a, b) end)
        |> then(&(elem(&1, 0) * 3 + elem(&1, 1)))
    end
  end

  def part_1(input) do
    Enum.map(input, fn {c1, c2} -> minimize_expression(c1, c2) end)
    |> Enum.sum()
  end

  def part_2(input) do
    Enum.map(input, &solve_part_2/1)
    |> Enum.sum()
  end

  def solve_part_2(%{
        a_x: a_x,
        b_x: b_x,
        a_y: a_y,
        b_y: b_y,
        x: x,
        y: y
      }) do
    b =
      (x * a_y - y * a_x) /
        (a_y * b_x - a_x * b_y)

    a = (y - b * b_y) / a_y
    a = round(a)
    b = round(b)

    if a * a_x + b * b_x == x and a * a_y + b * b_y == y do
      3 * a + b
    else
      0
    end
  end
end

"./input" |> File.read!() |> Day13.parse1() |> Day13.part_1() |> IO.inspect()
"./input" |> File.read!() |> Day13.parse2() |> Day13.part_2() |> IO.inspect()

defmodule Day14 do
  def parse(input) do
    pattern = ~r/p=(?<x>-?\d+),(?<y>-?\d+) v=(?<v_x>-?\d+),(?<v_y>-?\d+)/

    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      map = Regex.named_captures(pattern, line)

      %{
        x: String.to_integer(Map.get(map, "x")),
        y: String.to_integer(Map.get(map, "y")),
        v_x: String.to_integer(Map.get(map, "v_x")),
        v_y: String.to_integer(Map.get(map, "v_y"))
      }
    end)
  end

  def part_1(input, width, height) do
    input
    |> Enum.map(&step_n(&1, 100, width, height))
    |> group_by_quadrants(width, height)
    |> Enum.product()
  end

  def part_2(input, width, height) do
    Enum.reduce(
      Enum.to_list(1..10000),
      input,
      fn i, acc ->
        new_acc = Enum.map(acc, &step_n(&1, 1, width, height))

        new_acc |> to_printable_map() |> print(i, width, height)

        new_acc
      end
    )
    :ok
  end

  def step_n(%{x: x, y: y, v_x: v_x, v_y: v_y}, n, width, height) do
    new_x =
      case rem(n * v_x + x, width) do
        value when value < 0 ->
          width + value

        value ->
          value
      end

    new_y =
      case rem(n * v_y + y, height) do
        value when value < 0 ->
          height + value

        value ->
          value
      end

    %{x: new_x, y: new_y, v_x: v_x, v_y: v_y}
  end

  def group_by_quadrants(list, width, height) do
    q_width = floor(width / 2)
    q_height = floor(height / 2)

    Enum.frequencies_by(
      list,
      fn
        %{x: x, y: y} when x < q_width and y < q_height ->
          1

        %{x: x, y: y} when x > q_width and y < q_height ->
          2

        %{x: x, y: y} when x < q_width and y > q_height ->
          3

        %{x: x, y: y} when x > q_width and y > q_height ->
          4

        _ ->
          0
      end
    )
    |> Enum.reject(&(elem(&1, 0) == 0))
    |> Enum.map(&elem(&1, 1))
  end

  def to_printable_map(input) do
    try do
      Enum.reduce(
        input,
        %{},
        fn %{x: x, y: y}, acc ->
          Map.update(
            acc,
            {x, y},
            1,
            fn _value -> throw(:nonempty) end
          )
        end
      )
    catch
      :nonempty -> :no_print
    end
  end

  def print(:no_print, _i, _width, _height) do
    :ok
  end

  def print(input, i, width, height) do
    IO.puts(i)

    for i <- 0..(height - 1) do
      for j <- 0..(width - 1) do
        case Map.get(input, {j, i}) do
          nil -> IO.write(".")
          value -> IO.write(value)
        end
      end

      IO.write("\n")
    end

    :ok
  end
end

input = "./input" |> File.read!() |> Day14.parse()
input |> Day14.part_1(101, 103) |> IO.inspect()
input |> Day14.part_2(101, 103) |> IO.inspect()

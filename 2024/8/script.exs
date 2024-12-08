defmodule Day08 do
  def parse(input) do
    width = String.length(hd(String.split(input, "\n", trim: true)))
    height = length(String.split(input, "\n", trim: true))

    antennas =
      for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
          {char, x} when char != ?. <- Enum.with_index(to_charlist(line)) do
        {char, {x, y}}
      end
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.to_list()
      |> Enum.map(&elem(&1, 1))

    {width, height, antennas}
  end

  def antinodes({x1, y1}, {x2, y2}, steps) do
    steps
    |> Enum.reduce(
      [],
      fn step, acc ->
        acc ++
          [
            {x1 + step * (x1 - x2), y1 + step * (y1 - y2)},
            {x2 + step * (x2 - x1), y2 + step * (y2 - y1)}
          ]
      end
    )
  end

  def pairs(list) do
    Enum.flat_map(Enum.with_index(list), fn {item1, index1} ->
      Enum.map(Enum.slice(list, (index1 + 1)..-1//1), fn item2 ->
        {item1, item2}
      end)
    end)
  end

  def part_1({w, h, antennas}) do
    antennas
    |> Enum.reduce([], fn antenna, acc ->
      an =
        pairs(antenna)
        |> Enum.reduce([], &(&2 ++ antinodes(elem(&1, 0), elem(&1, 1), [1])))
        |> Enum.filter(
          &(elem(&1, 0) in 0..(w - 1) and
              elem(&1, 1) in 0..(h - 1))
        )

      acc ++ an
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part_2({w, h, antennas}) do
    antennas
    |> Enum.reduce([], fn antenna, acc ->
      an =
        pairs(antenna)
        |> Enum.reduce(
          [],
          &(&2 ++ antinodes(elem(&1, 0), elem(&1, 1), Enum.to_list(0..w)))
        )
        |> Enum.filter(
          &(elem(&1, 0) in 0..(w - 1) and
              elem(&1, 1) in 0..(h - 1))
        )

      acc ++ an
    end)
    |> Enum.uniq()
    |> Enum.count()
  end
end

input = "./input_small" |> File.read!() |> Day08.parse()
input |> Day08.part_1() |> IO.inspect()
input |> Day08.part_2() |> IO.inspect()

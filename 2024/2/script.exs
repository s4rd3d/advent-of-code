defmodule Day02 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn lines ->
      String.split(lines)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_1(lines) do
    lines
    |> Enum.map(&do_part_1/1)
    |> Enum.sum()
  end

  def do_part_1(line) do
    differences =
      line
      |> Enum.zip([0] ++ line)
      |> Enum.drop(1)
      |> Enum.map(&(elem(&1, 0) - elem(&1, 1)))

    Enum.reduce_while(
      differences,
      1,
      &cond do
        (hd(differences) < 0 and &1 < 0 and &1 > -4) or
            (hd(differences) >= 0 and &1 > 0 and &1 < 4) ->
          {:cont, &2}

        true ->
          {:halt, 0}
      end
    )
  end

  def part_2(lines) do
    lines
    |> Enum.map(&do_part_2/1)
    |> Enum.sum()
  end

  def do_part_2(line) do
    0..length(line)
    |> Enum.map(fn x -> line |> List.delete_at(x) |> do_part_1() end)
    |> Enum.sum()
    |> then(&if &1 > 0, do: 1, else: 0)
  end
end

input = "./input" |> File.read!() |> Day02.parse()
input |> Day02.part_1() |> IO.inspect()
input |> Day02.part_2() |> IO.puts()

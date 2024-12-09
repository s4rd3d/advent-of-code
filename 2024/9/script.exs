defmodule Day09 do
  def parse(input) do
    input |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  def part_1(input) do
    {disk, _} =
      input
      |> Enum.with_index()
      |> Enum.reduce(
        {[], 0},
        fn {val, idx}, {disk, file_id} ->
          case rem(idx, 2) do
            0 -> {disk ++ List.duplicate(file_id, val), file_id + 1}
            _ -> {disk ++ List.duplicate(".", val), file_id}
          end
        end
      )

      shift(disk, length(disk) - 1) |> score()
  end

  def shift(disk, -1), do: disk

  def shift(disk, i) do
    if Enum.at(disk, i) == "." or Enum.find_index(disk, &(&1 == ".")) > i do
      shift(disk, i - 1)
    else
      dot_index = Enum.find_index(disk, &(&1 == "."))
      disk = List.replace_at(disk, dot_index, Enum.at(disk, i))
      disk = List.replace_at(disk, i, ".")
      shift(disk, i - 1)
    end
  end

  def score(disk) do
    disk
    |> Enum.filter(&(&1 != "."))
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, idx}, acc -> acc + val * idx end)
  end

  def part_2(input) do
    input
  end
end

input = "./input" |> File.read!() |> Day09.parse()
input |> Day09.part_1() |> IO.inspect()
# input |> Day09.part_2() |> IO.inspect()

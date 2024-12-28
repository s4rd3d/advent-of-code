defmodule Day19 do
  def parse(input) do
    [patterns, designs] = String.split(input, "\n\n")
    {String.split(patterns, ", "), String.split(designs, "\n")}
  end

  def part_1({patterns, designs}) do
    Task.async_stream(designs, &ways_to_construct(&1, patterns), ordered: false)
    |> Stream.map(fn {:ok, n} -> n end)
    |> Enum.count(&(&1 > 0))
  end

  def part_2({patterns, designs}) do
    Task.async_stream(designs, &ways_to_construct(&1, patterns), ordered: false)
    |> Stream.map(fn {:ok, n} -> n end)
    |> Enum.sum()
  end

  def ways_to_construct("", _patterns), do: 1

  def ways_to_construct(design, patterns) do
    case Process.get(design) do
      nil ->
        Enum.reduce(patterns, 0, fn pattern, total ->
          case design do
            <<^pattern::binary, rest::binary>> ->
              total + ways_to_construct(rest, patterns)

            _ ->
              total
          end
        end)
        |> tap(&Process.put(design, &1))

      n ->
        n
    end
  end
end

input = "./input" |> File.read!() |> Day19.parse()
input |> Day19.part_1() |> IO.inspect()
input |> Day19.part_2() |> IO.inspect()

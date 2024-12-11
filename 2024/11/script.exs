defmodule Day11 do
  @cache :ets.new(:cache, [:named_table])
  @powers_of_ten Enum.map(0..20, &(:math.pow(10, &1) |> round))

  def parse(input) do
    input |> String.split() |> Enum.map(&String.to_integer/1)
  end

  def solve(input, iterations) do
    initial_counts = Enum.frequencies(input)

    Enum.reduce(
      1..iterations,
      initial_counts,
      fn _i, counts -> process_iteration(counts) end
    )
    |> Enum.reduce(0, &(&2 + elem(&1, 1)))
  end

  def process_iteration(counts) do
    Enum.reduce(
      counts,
      %{},
      fn {number, count}, acc ->
        result = operation(number)

        case result do
          [a, b] ->
            Map.update(acc, a, count, &(&1 + count))
            |> Map.update(b, count, &(&1 + count))

          n ->
            Map.update(acc, n, count, &(&1 + count))
        end
      end
    )
  end

  def operation(n) do
    case :ets.lookup(@cache, n) do
      [{_key, value}] ->
        value

      [] ->
        result = calculate_operation(n)
        :ets.insert(@cache, {n, result})
        result
    end
  end

  def calculate_operation(0), do: 1

  def calculate_operation(n) do
    digits = :math.log10(n) |> floor() |> Kernel.+(1) |> trunc()

    case rem(digits, 2) do
      0 ->
        divisor = Enum.at(@powers_of_ten, div(digits, 2))
        first_half = div(n, divisor)
        second_half = rem(n, divisor)
        [first_half, second_half]

      1 ->
        n * 2024
    end
  end
end

input = "./input" |> File.read!() |> Day11.parse()
input |> Day11.solve(25) |> IO.inspect()
input |> Day11.solve(75) |> IO.inspect()

defmodule Day17 do
  def parse(input) do
    pattern =
      ~r/Register A: (?<a>-?\d+)\nRegister B: (?<b>-?\d+)\nRegister C: (?<c>-?\d+)\n\nProgram: (?<program>-?(\d,)+\d)/

    map = Regex.named_captures(pattern, input)

    %{
      registers: %{
        a: String.to_integer(Map.get(map, "a")),
        b: String.to_integer(Map.get(map, "b")),
        c: String.to_integer(Map.get(map, "c"))
      },
      program:
        Map.get(map, "program")
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
    }
  end

  def part_1(input) do
    compute(input, 0, []) |> IO.inspect()
  end

  def part_2(%{registers: registers, program: program}) do
    for i <- 0..100 do
      compute(
        %{
          registers:
            Map.put(registers, :a, get_a(i)),
          program: program
        },
        0,
        []
      )
      |> IO.inspect(label: i)
    end
  end

  def get_a(i) do
    (:math.pow(8, 15) +
       0 * :math.pow(8, 15) +
       0 * :math.pow(8, 14) +
       0 * :math.pow(8, 13) +
       0 * :math.pow(8, 12) +
       0 * :math.pow(8, 11) +
       0 * :math.pow(8, 10) +
       0 * :math.pow(8, 9) +
       0 * :math.pow(8, 8) +
       0 * :math.pow(8, 7) +
       0 * :math.pow(8, 6) +
       0 * :math.pow(8, 5) +
       0 * :math.pow(8, 4) +
       0 * :math.pow(8, 3) +
       0 * :math.pow(8, 2) +
       0 * :math.pow(8, 1) +
       0 * :math.pow(8, 0))
    |> trunc
  end

  def compute(%{registers: registers, program: program}, pointer, result) do
    if pointer < length(program) - 1 do
      [opcode, operand] = Enum.slice(program, pointer, 2)

      {registers, pointer, result} =
        do_instruction(opcode, operand, registers, pointer, result)

      compute(%{registers: registers, program: program}, pointer, result)
    else
      Enum.reverse(result)
    end
  end

  def do_instruction(0, operand, %{a: a} = registers, pointer, result) do
    value = (a / :math.pow(2, combo(operand, registers))) |> trunc()
    {Map.put(registers, :a, value), pointer + 2, result}
  end

  def do_instruction(1, operand, %{b: b} = registers, pointer, result) do
    value = Bitwise.bxor(b, operand)
    {Map.put(registers, :b, value), pointer + 2, result}
  end

  def do_instruction(2, operand, registers, pointer, result) do
    value = combo(operand, registers) |> rem(8)
    {Map.put(registers, :b, value), pointer + 2, result}
  end

  def do_instruction(3, _operand, %{a: 0} = registers, pointer, result) do
    {registers, pointer + 2, result}
  end

  def do_instruction(3, operand, registers, _pointer, result) do
    {registers, operand, result}
  end

  def do_instruction(4, _operand, %{b: b, c: c} = registers, pointer, result) do
    value = Bitwise.bxor(b, c)
    {Map.put(registers, :b, value), pointer + 2, result}
  end

  def do_instruction(5, operand, registers, pointer, result) do
    value = combo(operand, registers) |> rem(8)
    {registers, pointer + 2, [value | result]}
  end

  def do_instruction(6, operand, %{a: a} = registers, pointer, result) do
    value = (a / :math.pow(2, combo(operand, registers))) |> trunc()
    {Map.put(registers, :b, value), pointer + 2, result}
  end

  def do_instruction(7, operand, %{a: a} = registers, pointer, result) do
    value = (a / :math.pow(2, combo(operand, registers))) |> trunc()
    {Map.put(registers, :c, value), pointer + 2, result}
  end

  def combo(operand, _registers) when operand < 4, do: operand
  def combo(4, registers), do: Map.get(registers, :a)
  def combo(5, registers), do: Map.get(registers, :b)
  def combo(6, registers), do: Map.get(registers, :c)
  def combo(7, _registers), do: throw(:invalid_program)
end

input = "./input" |> File.read!() |> Day17.parse()
# input |> Day17.part_1()
input |> Day17.part_2()

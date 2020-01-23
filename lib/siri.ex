defmodule Siri do
  @doc """
  Provide requested information.  According to the weather API, it is "sunny" from (including) 6am to 6pm (including), and "raining" the rest of the day.

  Examples (these are executable doctests):

      iex> Siri.answer "Add 7 to 15."
      22

      iex> Siri.answer "Subtract 7 from 15."
      8

      iex> Siri.answer "What is the weather at 5:30pm?"
      "sunny"

      iex> Siri.answer "What is the weather at 6:30pm?"
      "raining"

      iex> Siri.answer "What is the meaning of life?"
      "Sorry, I don't understand."
  """
  def answer(question) do
    cond do
      [_, a, b] = Regex.run(~r/^Add (\d+) to (\d+)./, question) -> add(a, b)
      [_, a, b] = Regex.run(~r/^Subtract (\d+) from (\d+)./, question) -> subtract(b, a)
      true -> "Sorry, I don't understand."
    end
  end

  defp add(a, b), do: String.to_integer(a) + String.to_integer(b)
  defp subtract(a, b), do: String.to_integer(a) - String.to_integer(b)
end

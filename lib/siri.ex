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
    {question, nil}
    |> try_pattern(~r/^Add (\d+) to (\d+)./, &add/1)
    |> try_pattern(~r/^Subtract (\d+) from (\d+)./, &subtract/1)
    |> return_answer()
  end

  defp try_pattern({question, nil}, pattern, handler) do
    case Regex.run(pattern, question, capture: :all_but_first) do
      nil -> {question, nil}
      matches -> {question, handler.(matches)}
    end
  end

  defp try_pattern(already_answered, _pattern, _handler), do: already_answered
  defp return_answer({_question, nil}), do: "Sorry, I don't understand."
  defp return_answer({_question, answer}), do: answer

  defp add([a, b]), do: String.to_integer(a) + String.to_integer(b)
  defp subtract([a, b]), do: String.to_integer(b) - String.to_integer(a)
end

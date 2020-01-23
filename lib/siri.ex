defmodule Siri do
  @doc """
  Provide requested information.  According to the weather API, it is "sunny"
  from (including) 6am to 6pm (including), and "raining" the rest of the day.

  Examples (these are executable doctests):

      iex> Siri.answer "Add 7 to 15."
      22
      iex> Siri.answer "Subtract 7 from 15."
      8
      iex> Siri.answer "What is the weather at 5:30pm?"
      "sunny"
      iex> Siri.answer "What is the weather at 6:00pm?"
      "sunny"
      iex> Siri.answer "What is the weather at 6:01pm?"
      "raining"
      iex> Siri.answer "What is the weather at 5:59am?"
      "raining"
      iex> Siri.answer "What is the weather at 6:00am?"
      "sunny"
      iex> Siri.answer "What is the meaning of life?"
      "Sorry, I don't understand."
  """
  def answer(question) do
    {question, nil}
    |> try_pattern(~r/^Add (\d+) to (\d+)./, &add/1)
    |> try_pattern(~r/^Subtract (\d+) from (\d+)./, &subtract/1)
    |> try_pattern(~r/^What is the weather at (\d+):(\d+)(am|pm)?/, &weather/1)
    |> return_answer()
  end

  defp try_pattern({question, nil}, pattern, handler) do
    pattern
    |> Regex.run(question, capture: :all_but_first)
    |> handle_match(question, handler)
  end

  defp try_pattern(already_answered, _pattern, _handler), do: already_answered

  defp handle_match(nil = _matches, question, _handler), do: {question, nil}
  defp handle_match(matches, question, handler), do: {question, handler.(matches)}

  defp return_answer({_question, nil}), do: "Sorry, I don't understand."
  defp return_answer({_question, answer}), do: answer

  defp add([a, b]), do: String.to_integer(a) + String.to_integer(b)
  defp subtract([a, b]), do: String.to_integer(b) - String.to_integer(a)

  defp weather([hour, minute, am_or_pm]), do: time(hour, minute, am_or_pm) |> forecast

  defp time(hour, minute, "am"), do: time(hour, minute)
  defp time(hour, minute, "pm"), do: time(hour, minute) + 60 * 12
  defp time(hour, minute), do: String.to_integer(hour) * 60 + String.to_integer(minute)

  defp forecast(time) when time >= 60 * 6 and time <= 60 * 18, do: "sunny"
  defp forecast(_time), do: "raining"
end

defmodule AI do
	
	defp addition_question(first_number, second_number) do
		"Is the result of #{first_number} + #{second_number} even?"
	end
	
	defp say_answer(true) do
		"Yes!! We found an even number"
	end
	
	defp say_answer(false) do
		"No. Don't give up"
	end

	defp even?(number) when is_number(number) do
		if rem(number, 2) == 0, do: true, else: false
	end

	defp generate(amount_of_questions) when is_number(amount_of_questions) do
		generate(0, amount_of_questions)
	end
		
	defp generate(accumulator, amount_of_questions) when amount_of_questions >= 1 do
		question = addition_question(Enum.random(1..100_000), Enum.random(1..100_000))
		build_list(question)
		generate(accumulator + 1, amount_of_questions - 1)
	end
	
	defp generate(total, 0) do
		IO.puts("#{total} addition questions generated")
		:ok
	end

	defp start_list do
		Agent.start(fn() -> [] end, [name: __MODULE__])
	end

	defp build_list(question) do
		Agent.update(__MODULE__, fn(list) -> [question | list] end)
	end
	
	defp questions do
		Agent.get(__MODULE__, &(&1))
	end

	defp answer_to(question) do
		Regex.scan(~r/(\d+) \+ (\d+)/, question, [capture: :all_but_first])
		|>List.flatten
		|> Enum.map(&String.to_integer(&1))
		|>Enum.reduce(0, fn(n, acc) -> n + acc end)
		|>even?
		|>say_answer
	end

	defp display_answer_for(question) do
		IO.puts(question)
		IO.puts(answer_to(question))
	end

	def start do
		start_list
		generate(20)
		Enum.each(questions, &display_answer_for(&1))		
	end
end

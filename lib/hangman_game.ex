defmodule HangmanGame do
  @moduledoc """
  Documentation for `HangmanGame`.
  """

  @doc """

  """
  def start(_type, _args) do
    game("", :player1, 0)
  end

  def game(keyword, player, lifes) do
    case player do
      :player1 -> player1_game()

      :player2 -> player2_game(keyword, lifes)
    end
  end

  defp player1_game do
    keyword = IO.gets("Jogador 1: insira uma palavra para a forca: ")|> String.trim()
    lifes = IO.gets("Jogador 1: insira a quantidade de vidas: ")
        |> String.trim()
        |> String.to_integer()

    game(create_keyword_struct(keyword), :player2, lifes)
  end

  defp create_keyword_struct(keyword) do
    [Enum.map(String.split(keyword, "", trim: true), fn char  -> {char, 0} end), keyword]
  end

  defp player2_game(_keywords, lifes) when lifes == 0, do: game_over("Acabaram as vidas: FIM DE JOGO.")

  defp player2_game([keyword_struct, keyword], lifes) do
    IO.puts("\e[H\e[2J")

    show_words(keyword_struct)

    if is_game_over?(keyword_struct), do: game_over("\n A palavra é: #{keyword}. Você venceu!") 

    guess = IO.gets("\n Jogador 2[vidas: #{lifes}]: insira uma letra para adivinhar a palavra:") |> String.trim()

    if String.contains?(keyword, guess) do
      game([updating_keyword_struct(keyword_struct, guess), keyword], :player2, lifes)
    else
      game([keyword_struct, keyword], :player2, lifes - 1)
    end
  end

  defp is_game_over?(keyword_struct) do
    Enum.all?(keyword_struct, fn {_char, status} -> status == 1 end)
  end
  
  defp game_over(msg) do
    IO.puts(msg)
    System.halt(0)
  end

  defp updating_keyword_struct(keyword_struct, key) do
    Enum.map(keyword_struct, fn {char, status} ->
      if char == key do
        {char, 1}
      else
        {char, status}
      end
    end)
  end

  defp show_words(keyword) do
    Enum.map(keyword, fn {char, status}  ->
      if status == 1 do
        IO.write(" #{char} ")
      else
        IO.write(" _ ")
      end
    end)
  end
end

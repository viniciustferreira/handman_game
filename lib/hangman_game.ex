defmodule HangmanGame do
  @moduledoc """
  Documentation for `HangmanGame`.
  """

  @doc """

  """
  def start(_type, _args) do
    game("", :player1, 0)
  end

  def game(keyword, player, lives) do
    case player do
      :player1 -> player1_game()

      :player2 -> player2_game(keyword, lives)
    end
  end

  defp player1_game do
    keyword = IO.gets("Jogador 1: insira uma palavra para a forca: ")
    lives = IO.gets("Jogador 1: insira a quantidade de vidas: ")

    amount_lives = lives
    |> String.trim()
    |> String.to_integer()

    game(create_keyword_struct(keyword), :player2, amount_lives)
  end

  defp create_keyword_struct(keyword) do
    keyword_struct = keyword
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map( fn char  -> {char, 0} end)

    [keyword_struct, keyword]
  end

  defp player2_game(_keywords, lives) when lives == 0, do: game_over("Acabaram as vidas: FIM DE JOGO.")

  defp player2_game([keyword_struct, keyword], lives) do
    IO.puts("\e[H\e[2J")

    show_words(keyword_struct)

    if is_game_over?(keyword_struct), do: game_over("\n Você venceu!")

    guess = IO.gets("\n Jogador 2[vidas: #{lives}]: insira uma letra para adivinhar a palavra:")

    guess = String.trim(guess)

    if String.contains?(keyword, guess) do
      game([updating_keyword_struct(keyword_struct, guess), keyword], :player2, lives)
    else
      game([keyword_struct, keyword], :player2, lives - 1)
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

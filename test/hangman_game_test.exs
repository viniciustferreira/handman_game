defmodule HangmanGameTest do
  use ExUnit.Case
  doctest HangmanGame

  describe "game" do
    test "create a player1 game" do
      assert {} = HangmanGame.game("", :player1, 0)
    end
  end
end

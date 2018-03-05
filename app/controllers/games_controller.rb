require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    @letters = alphabet.sample(10)
  end

  def score
    @letters = params[:letters].upcase
    @answer = params[:answer]
    @final = score_and_message(@answer, @letters)
  end

  private

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        "Congratulations !!! #{@answer} is a valid word!"
      else
        "Sorry but #{@answer} doesn't seem to be a valid english word"
      end
    else
      "Sorry but #{@answer} can't be built out of #{@letters}"
    end
  end
  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end


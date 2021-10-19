# frozen_string_literal: true

require 'open-uri'
require 'json'

# Question controller
class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @grid = params[:grid]
    @word = params[:word]
    @score = word_score(@word, @grid)
  end

  private

  def generate_grid(grid_size)
    # Generate random grid of letters
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def word_score(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = attempt.size
      else
        score = 0
      end
    else
      score = -1
    end
  end
end

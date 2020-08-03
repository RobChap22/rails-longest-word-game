require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @result = { score: 0, message: 'Sorry, not in the grid.' } # time: end_time - start_time,
    return @result unless grid_check?(params[:answer], params[:letters])

    if dictionary?(params[:answer])
      @result[:score] = (params[:answer].length * 10) #- result[:time]
      @result[:message] = 'Well done!'
    else
      @result[:message] = 'Sorry, that is not an English word.'
    end
    @result
  end

  private

  def grid_check?(attempt, grid)
    attempt.upcase.chars.all? { |letter| attempt.upcase.chars.count(letter) <= grid.count(letter) }
  end

  def dictionary?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary_data = open(url).read
    word = JSON.parse(dictionary_data)
    word['found']
  end
end

class GamesController < ApplicationController
  def index
    @games = Game.all
  end
end
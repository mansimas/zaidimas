class MonstersController < ApplicationController

  def index
  end
  
  def new
    puts "adada"
  end

  def show
  end

  def edit
  end

  def create
  end

  def update
    id = monster_params[:id]  
    xpos = monster_params[:Xpos] 
    ypos = monster_params[:Ypos] 
    xposDest = monster_params[:XposDest] 
    yposDest = monster_params[:YposDest] 
    level = monster_params[:level]
    health = monster_params[:health]
    $redis.hset 'mobs', id, "[#{xpos}, #{ypos}, #{xposDest}, #{yposDest}, #{level}, #{health}]"
    respond_to do |format|
       format.html do
           render nothing: true
       end   
     end
  end

  def destroy
  end

  private
    def monster_params
      params.require(:monster)
    end
end

class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Stat.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Stat.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Stat.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Stat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:stat, :health, :strength, :user_id, :experience, :level, :player_hp, :max_hp, :attack_allow, :money, :min_dmg, :max_dmg, :speed, :agility, :defence, :critical, :critical_multiplier, :evasion, :accuracy, :exp_left, :medicine1, :medicine2, :medicine3, :medicine4, :medicine5, :medicine6, :medicine7, :medicine8, :medicine9, :medicine10, :medicine_time,
:weapon_name,
:weapon_user_id,
:weapon_strength,
:weapon_health,
:weapon_agility,
:weapon_level,
:weapon_defence,
:armor_name,
:armor_user_id,
:armor_strength,
:armor_health,
:armor_agility,
:armor_level,
:armor_defence,
:weapon_itemname,
:armor_itemname,
:gloves_itemname,
:shoes_itemname,
:helmet_itemname,
:gloves_name,
:gloves_user_id,
:gloves_strength,
:gloves_health,
:gloves_agility,
:gloves_level,
:gloves_defence,
:shoes_name,
:shoes_user_id,
:shoes_strength,
:shoes_health,
:shoes_agility,
:shoes_level,
:shoes_defence,
:helmet_name,
:helmet_user_id,
:helmet_strength,
:helmet_health,
:helmet_agility,
:helmet_level,
:weapon_money,
:armor_money,
:gloves_money,
:shoes_money,
:helmet_money,
:helmet_defence, :total_strength, :total_health, :total_agility, :total_defence,
:weapon_grade, :armor_grade, :shoes_grade, :helmet_grade, :gloves_grade)
    end
end

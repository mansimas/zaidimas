require 'test_helper'

class ShopsControllerTest < ActionController::TestCase
  setup do
    @shop = shops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shop" do
    assert_difference('Shop.count') do
      post :create, shop: { agility: @shop.agility, count: @shop.count, critical: @shop.critical, critical_multiplier: @shop.critical_multiplier, defence: @shop.defence, experience: @shop.experience, grade: @shop.grade, health: @shop.health, hp: @shop.hp, item: @shop.item, itemname: @shop.itemname, level: @shop.level, max_dmg: @shop.max_dmg, min_dmg: @shop.min_dmg, money: @shop.money, speed: @shop.speed, strength: @shop.strength, user_id: @shop.user_id }
    end

    assert_redirected_to shop_path(assigns(:shop))
  end

  test "should show shop" do
    get :show, id: @shop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shop
    assert_response :success
  end

  test "should update shop" do
    patch :update, id: @shop, shop: { agility: @shop.agility, count: @shop.count, critical: @shop.critical, critical_multiplier: @shop.critical_multiplier, defence: @shop.defence, experience: @shop.experience, grade: @shop.grade, health: @shop.health, hp: @shop.hp, item: @shop.item, itemname: @shop.itemname, level: @shop.level, max_dmg: @shop.max_dmg, min_dmg: @shop.min_dmg, money: @shop.money, speed: @shop.speed, strength: @shop.strength, user_id: @shop.user_id }
    assert_redirected_to shop_path(assigns(:shop))
  end

  test "should destroy shop" do
    assert_difference('Shop.count', -1) do
      delete :destroy, id: @shop
    end

    assert_redirected_to shops_path
  end
end

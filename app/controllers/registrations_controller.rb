class RegistrationsController < Devise::RegistrationsController 
  def update
    new_params = params.require(:user).permit(:email, :username, :current_password, :password, :password_confirmation) 
    change_password = true 
    if params[:user][:password].blank? 
      params[:user].delete("password") 
      params[:user].delete("password_confirmation")
      new_params = params.require(:user).permit(:email, :username) 
      change_password = false 
    end 

    @user = User.find(current_user.id) 
    is_valid = false 
    if change_password 
      is_valid = @user.update_with_password(new_params) 
    else 
      @user.update_without_password(new_params) 
    end 
    if is_valid 
      set_flash_message :notice, :updated 
      sign_in @user, :bypass => true 
      redirect_to after_update_path_for(@user) 
    else 
      render "edit" 
    end 
  end
   def create
    build_resource(sign_up_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
      Stat.create("stat" => 0, "health" => 5, "strength" => 5, "user_id" => current_user.id, "experience" => 0, "level" => 1, "username" => current_user.username, "speed"=>1000, "agility" => 0, "max_hp" => 100, "player_hp" => 100, "critical" => 0, "critical_multiplier" => 2, "money" => 0, "defence" => 0, "evasion" => 0, "accuracy" => 0, "attack_allow" => true, "medicine1" =>0, "medicine2" =>0, "medicine3" =>0, "medicine4" =>0, "medicine5" =>0, "medicine6" =>0, "medicine7" =>0, "medicine8" =>0, "medicine9" =>0, "medicine10" =>0)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end 
end


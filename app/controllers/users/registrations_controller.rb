#I had written this when I thought I needed to add a custom controller for registration and had modified the routes. It turns out that 
#all I needed to do was to updated application controller and added a new piece of code to require image
class Users::RegistrationsController < Devise::RegistrationsController
   before_filter :configure_permitted_parameters, if: :devise_controller?

  def update

    #if params[configure_permitted_parameters][:image].blank?
      #super
    #else
        #@user=resource
        #respond_to do |format|
         #if resource.update_attributes(params[resource_name])
            #flash[:notice]='Avatar successfully uploaded.'
            #format.html {
                    #render :action => 'crop'
            #}
           #format.xml  { head :ok }
          #else
            #format.html { render :action => "editpicture" }
            #format.xml  { render :xml => @demotivator.errors, :status => :unprocessable_entity }
          #end
       #end
    #end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        #format.html { render action: 'edit' }
        #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end


  end

  protected

    #def resource_name
      #params.require(:pin).permit(:description, :image)
      #params.require(:user).permit(:image)
    #end

    def user_params
      params.require(:user).permit(:image)
    end

    def configure_permitted_parameters
      #devise_parameter_sanitizer.for(:account_update) do |u|
      devise_parameter_sanitizer.for(:user) do |u|
      #u.permit(:image, :email, :password, :password_confirmation)
      u.permit(:image, :password)
      end
    end

end
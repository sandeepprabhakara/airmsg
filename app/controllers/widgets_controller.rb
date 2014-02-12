class WidgetsController < ApplicationController
	layout nil
	API_KEY_REGEX = 1
  #session :off
	def ilove
	  #@content = render_to_string(:partial => 'widgets/ilove_widget')
	  @spots = Relationship.where("responder_id = ?", current_user.id).count
	  #render :layout => false
	end

	protected
  def validate_api_key
    # Assuming we defined API_KEY_REGEX elsewhere
    return render(:text => 'Invalid API key.') unless params[:api_key] =~ API_KEY_REGEX

    # You may want to validate the key against your database and/or log the request
    return render(:text => 'Invalid API key.') if not @key = Key.find_by_hash(params[:api_key])
  end

end
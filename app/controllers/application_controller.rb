class ApplicationController < ActionController::Base
	include ApplicationHelper
 	before_action :logged_in_user
end

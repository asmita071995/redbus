class HomesController < ApplicationController
   skip_before_action :logged_in_user
end

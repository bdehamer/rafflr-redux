class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery :secret => '8f8564e819692662964e08450dfd1172'
end

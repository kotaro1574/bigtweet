class ApplicationController < ActionController::Base
  protect_from_forgery :except => [:make] # この行を追加
end

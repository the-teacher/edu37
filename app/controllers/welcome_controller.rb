class WelcomeController < ApplicationController
  include SimpleCaptcha::ControllerValidation
                           
  def index; end
end

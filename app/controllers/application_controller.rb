class ApplicationController < ActionController::Base
  def hello
    render html: "g'day m8"
  end
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'warning'
Gem.path.each do |path|
  Warning.ignore(//, path)
end

class ActiveSupport::TestCase
  include ApplicationHelper
  parallelize(workers: :number_of_processors)

  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end
end

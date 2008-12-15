require File.dirname(__FILE__) + '/tumblr/api'
require File.dirname(__FILE__) + '/tumblr/post'

module Tumblr
  
  @defaults = {
    :account   => "",
    :email     => "",
    :password  => "",
    :generator => "Tumblr gem v0.0.1"
  }

  def self.defaults
    @defaults
  end
  
end
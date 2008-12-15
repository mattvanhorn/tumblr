require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/tumblr'
include Net
include Tumblr

describe "Tumblr::Api" do
  before(:each) do
    Tumblr.defaults[:account] = 'testing'
  end
  
  it "should read posts" do
    mock_get_response('http://testing.tumblr.com/api/read/?type=regular', 'read.xml')
    
    posts = Tumblr::Api::read(:type => 'regular')
    posts.should have(3).posts
    posts.each{|p| p.should be_a_kind_of(RegularPost)}
  end
  
  it "should write a new post" do
    post_params = { :fake => 'options', 
                    :email      => Tumblr::defaults[:email], 
                    :password   => Tumblr::defaults[:password], 
                    :generator  => Tumblr::defaults[:generator]}
    mock_post_response('http://testing.tumblr.com/api/write/', post_params)
    
    response = Tumblr::Api::write(post_params)
    response.code.should == '201'
    response.body.should =~ /^[0-9]+$/
  end
end

private

def mock_get_response(url, file)
  Tumblr::Api.should_receive(:open).with(url).and_return(File.read(File.dirname(__FILE__) + "/responses/#{file}"))
end

# * 201 Created     - Success! The newly created post's ID is returned.
# * 403 Forbidden   - Your email address or password were incorrect.
# * 400 Bad Request - There was at least one error while trying to save your post. Errors are sent in plain text, one per line.
def mock_post_response(url, post_params, resp = {:code => '201', :body => '123456'})
  # stringify post params
  post_params = post_params.inject({}){|r,h| r["#{h.first}"] = h.last; r  }
  response = mock('HTTPCreated', :code => resp[:code], :body => resp[:body])
  Net::HTTP.should_receive(:post_form).with(URI.parse(url),post_params).and_return(response)
end

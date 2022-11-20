require "test_helper"

class EndpointTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should save endpoint' do 
    # endpoint = Endpoint.new(verb: 'GET', path: '/testhello', response: [ code: 200, headers:{}, body: "{\"message\":\"hello test\"}"])
    endpoint = Endpoint.new(verb: 'GET', path: '/testhello', response: '')
    assert endpoint.save, 'Endpoint not saved'
    
  end
end

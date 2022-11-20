require "test_helper"

class EndpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @endpoint = endpoints(:data)
  end

  test "should get index" do
    get endpoints_url
    assert_response :success
  end

  # test "should get index" do
  #   get endpoints_url

  #   test_content = JSON.generate(response.body)
  #   puts content_
  #   # get endpoints_url, as: :json
  #   # assert_response :success
  # end

  test "should get new" do
    get new_endpoint_url
    assert_response :success
  end

  test "should create endpoint" do
    assert_difference("Endpoint.count") do
      post endpoints_url,
           params: { endpoint: { path: @endpoint.path, response: @endpoint.response, verb: @endpoint.verb } }
    end

    assert_redirected_to endpoint_url(Endpoint.last)
  end

  test "should show endpoint" do

    get endpoint_url(Endpoint.first), headers: { "HTTP_REFERER" => "http://example.com/home" }

    # puts JSON.parse(@endpoint)
    # get endpoint_url(@endpoint), as: :json
    assert_response :success
  end

  test "should get edit" do
    get edit_endpoint_url(@endpoint)
    assert_response :success
  end

  test "should update endpoint" do
    patch endpoint_url(@endpoint),
          params: { endpoint: { path: @endpoint.path, response: @endpoint.response, verb: @endpoint.verb } }
    assert_redirected_to endpoint_url(@endpoint)
  end

  test "should destroy endpoint" do
    assert_difference("Endpoint.count", -1) do
      delete endpoint_url(@endpoint)
    end

    assert_response :success
  end
end

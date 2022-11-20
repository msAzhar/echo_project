class EndpointsController < ApplicationController
  before_action :set_endpoint, only: %i[show edit update destroy]

  skip_before_action :verify_authenticity_token

  def index
    @endpoints = Endpoint.all

    render json: @endpoints, status: :ok
  end

  def show
  end

  def new
    @endpoint = Endpoint.new

    render jsonapi: @endpoint, status: :ok
  end

  def edit
  end

  def create
    @endpoint = Endpoint.new(endpoint_params)

    if @endpoint.save
      render jsonapi: @endpoint, status: :created
    else
      render jsonapi_errors: @endpoint.errors, status: :unprocessable_entity
    end
  end

  def update
    if @endpoint.update(endpoint_params)
      render jsonapi: @endpoint, status: :ok
    else
      render jsonapi: @endpoint.errors, status: :unprocessable_entity
    end
  end

  def echo
    endpoint = Endpoint.find_by(path: request.path, verb: request.method)

    if endpoint.present?
      endpoint.headers.each do |key, value|
        response.headers[key] = value
      end

      render json: JSON.parse(endpoint.body), status: endpoint.code
    else
      render json: {
        errors: [
          {
            code: 'not_found',
            detail: "Request page #{request.path} does not exist!"
          }
        ]
      }, status: 404
    end
  end

  def destroy
    @endpoint.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_endpoint
    @endpoint = Endpoint.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def endpoint_params
    params.require(:data).require(:attributes).permit(:verb, :path, response: [:code, { headers: {} }, :body])
  end
end

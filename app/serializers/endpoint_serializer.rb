class EndpointSerializer
  include JSONAPI::Serializer
  attributes :verb, :path, :response
end

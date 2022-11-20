JSON_API_MIME_TYPES = %w[
  application/vnd.api+json
  text/x-json
  application/json
].freeze

Mime::Type.unregister :json
Mime::Type.register 'application/vnd.api+json', :json, JSON_API_MIME_TYPES
Mime::Type.register_alias 'application/vnd.api+json', :json, %i[json_api jsonapi]

# Mime::Type.register 'application/vnd.api+json', :json, api_mime_types
class Endpoint < ApplicationRecord
  # store :response, accessors: %i[code headers body], coder: JSON
  store :response, accessors: %i[code headers body], coder: JSON
  # store_accessor :response, :code, :headers,:body

  validates :path, presence: true
  validates :verb, inclusion: { in: %w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE] }
  validates :code, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 599 }
end

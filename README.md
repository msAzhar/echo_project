# ECHO

The main goal of this project is to serve mock endpoints created with parameters specified by clients. 
Endpoints API is a set of endpoints(`GET|POST|PATCH|DELETE /endpoints{/:id}`) to manage those mock endpoints. 

### Endpoint API

Using EndpoinAPI, clients will be able to:

* Create Endpoint items

* Read Endpoint items

* Update Endpoint items

* Delete Endpoint items

* Read created mock endpoints

<br>

Endpoint entity's attributes are given below:

```
Endpoint {
      id    String  # identifier
      verb  String  # one of HTTP method names (GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE)
      path  String  # value of the path part of URL (/foo)

      response {
        code    Integer  # status code
        headers Hash<String, String>. # HTTP headers
        body    String  # response message
      }
    }
```

Let's imagine that client created the endpoint 'GET /foo/bar' using Endpoint API. The client will be able to access the body of that endpoint: `{ "message": "Hello world" }` .

## Building Endpoint API

First, install [Ruby on Rails](https://guides.rubyonrails.org/v5.1/getting_started.html) and create a new Rails app. Then, create a model representing endpoint by running the following code:
```
rails g model Endpoint verb path response
```
This tells Rails to create a new model called `Endpoint` and to define atribute field `verb`, `path` and `response`. This generator created several files and one of them is `db/migrate/_create_endpoints.rb` file that contains a migration:

```
class CreateEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :endpoints do |t|
      t.string :path
      t.string :verb
      t.string :response

      t.timestamps
    end
  end
end
```
It is a class that tells Rails how to make a change to a database. For that, run `rails db:migrate`.

Then, define validations for the attribute fields of the Endpoint entity:

```
class Endpoint < ApplicationRecord
  store :response, accessors: %i[code headers body], coder: JSON

  validates :path, presence: true
  validates :verb, inclusion: { in: %w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE] }
  validates :code, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 599 }
end
```
<br>
<br>

As the next step, create a controller for endpoint by running the following code:
```
rails g controller endpoint
```

Generated endpoint controller class automatically provides some main functions (such as index, show, create, update etc.) that we edit according to our needs:

```
class EndpointsController < ApplicationController
  before_action :set_endpoint, only: %i[show update destroy]

  def index
    @endpoints = Endpoint.all

    render jsonapi: @endpoints, status: :ok
  end

  ...

  # Only allow a list of trusted parameters through.
  def endpoint_params
    params.require(:data).require(:attributes).permit(:path, :verb, response: [:code, :body, { headers: {} }])
  end
end

```
<br>
<br>

In order to provide response in JSON format, add these gems into your `Gemfile`:

```
gem 'jsonapi.rb'
gem 'jsonapi-serializer'
```

Then create a serializor for the endpoint class by running:
```
rails g serializer endpoint
```

Here is the serializer class where we add defined attributes:
```
class EndpointSerializer
  include JSONAPI::Serializer
  attributes :verb, :path, :response
end
```
<br>
<br>

The main goal of this project is to show the content (body) of the created endpoint. For that, we define a function `echo`, which is responsible for handling the mock endpoint. This function is defined inside the `EndpointController` file: 

```
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
```  

Then, we define routes for mock endpoints by adding this line to the `routes.rb`:

```  
match '*path', to: 'endpoints#echo', via: :all
```  
  
<br>
<br>

Finally, run the application:
```
rails s
```

<hr/>

Here are several services of the Endpoint API. In the first example we list all existing endpoints using the `GET` method.

![GET, list all endpoints](/public/ex1.png "Listing all endpoints using postman")

<br>
<br>

In the next example we create a new endpoint using the `POST` method:

![POST, create a new endpoint](/public/ex2.png "Creating a new endpoint using postman")

<br>
<br>

Finally, we check the access to the body of the endpoint created by a client using the Endpoint API:

![GET, get the body of an endpoint](/public/ex3.png "Checking the body of the endpoint using postman")



















..
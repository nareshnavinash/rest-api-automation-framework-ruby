# frozen_string_literal: true

describe 'API tests for customer app' do
  before(:context) do
    @api = ClientApi::Api.new
    @test_data = Libraries::Config.load_test_data('client_library.yml')
  end

  it 'Post request with a name: in the request body', :regression, :sanity do |e|
    e.run_step('Raise a post request with name in the request body') do
      @api.post('/', { 'name': @test_data.fetch('name') })
    end
    e.run_step('Expect status of the response to be 200') do
      expect(@api.status).to eq(200)
    end
    e.run_step('Validate the response structure') do
      validate(@api.body,
               { key: 'name', has_key: true, empty: false, operator: '==', value: @test_data.fetch('name'),
                 type: 'string' },
               { key: 'timestamp', has_key: true, empty: false, type: 'string' },
               { key: 'customers', has_key: true, empty: false, type: 'array' })
      validate(@api.body['customers'][0],
               { key: 'id', has_key: true, empty: false, type: 'integer' },
               { key: 'name', has_key: true, empty: false, type: 'string' },
               { key: 'employees', has_key: true, empty: false, type: 'integer' },
               { key: 'size', has_key: true, empty: false, type: 'string' },
               { key: 'contactInfo', empty: false, type: 'hash' })
    end
    e.run_step('Validate the sorting of the customers list in the response') do
      validate_list(@api.body, { "key": 'customers', "unit": 'id', "sort": 'ascending' })
    end
    e.run_step('Validate the response headers') do
      validate_headers(@api.response_headers,
                       { key: 'connection', operator: '!=', value: 'open' },
                       { key: 'content-type', operator: '==', value: 'application/json; charset=utf-8' })
    end
  end

  it 'Post request without a name: in the request body', :regression do |e|
    e.run_step('Raise a post request with name in the request body') do
      @api.post('/', {})
    end
    e.run_step('Expect status of the response to be 200') do
      expect(@api.status).to eq(200)
    end
    e.run_step('Validate the response structure') do
      validate(@api.body,
               { key: 'name', has_key: false },
               { key: 'timestamp', has_key: true, empty: false, type: 'string' },
               { key: 'customers', has_key: true, empty: false, type: 'array' })
    end
    e.run_step('Validate the sorting of the customers list in the response') do
      validate_list(@api.body, { "key": 'customers', "unit": 'id', "sort": 'ascending' })
    end
    e.run_step('Validate the response headers') do
      validate_headers(@api.response_headers,
                       { key: 'connection', operator: '!=', value: 'open' },
                       { key: 'content-type', operator: '==', value: 'application/json; charset=utf-8' })
    end
  end

  it 'Post request with a name: in the request body and content type as text in request header',
     :regression do |e|
    e.run_step('Raise a post request with name in the request body') do
      @api.post('/', { 'name': @test_data.fetch('name') },
                { 'Content-Type' => 'text', 'Accept' => 'application/json' })
    end
    e.run_step('Expect status of the response to be 200') do
      expect(@api.status).to eq(200)
    end
    e.run_step('Validate the response structure') do
      validate(@api.body,
               { key: 'name', has_key: false },
               { key: 'timestamp', has_key: true, empty: false, type: 'string' },
               { key: 'customers', has_key: true, empty: false, type: 'array' })
    end
    e.run_step('Validate the sorting of the customers list in the response') do
      validate_list(@api.body, { "key": 'customers', "unit": 'id', "sort": 'ascending' })
    end
    e.run_step('Validate the response headers') do
      validate_headers(@api.response_headers,
                       { key: 'connection', operator: '!=', value: 'open' },
                       { key: 'content-type', operator: '==', value: 'application/json; charset=utf-8' })
    end
  end
end

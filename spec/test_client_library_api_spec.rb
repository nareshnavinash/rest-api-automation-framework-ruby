# frozen_string_literal: true

describe 'API tests for customer app' do
  let(:api) { ClientApi::Api.new }
  let(:helper) { ClientLibrary.new }

  let(:validate_client_list_response_header) do
    validate_headers(api.response_headers,
                     { key: 'connection', operator: '==', value: 'close' },
                     { key: 'content-type', operator: '==', value: 'application/json; charset=utf-8' })
  end

  let(:validate_customer_list_client_structure) do
    validate(api.body['customers'][0],
             { key: 'id', has_key: true, empty: false, type: 'integer' },
             { key: 'name', has_key: true, empty: false, type: 'string' },
             { key: 'employees', has_key: true, empty: false, type: 'integer' },
             { key: 'size', has_key: true, empty: false, type: 'string' },
             { key: 'contactInfo', empty: false, type: 'hash' })
  end

  let(:validate_client_list_response_body) do
    validate(api.body,
             { key: 'timestamp', has_key: true, empty: false, type: 'string' },
             { key: 'customers', has_key: true, empty: false, type: 'array' })
  end

  let(:validate_client_list_sort) do
    validate_list(api.body, { "key": 'customers', "unit": 'id', "sort": 'ascending' })
  end

  let(:validate_size_of_org) do
    api.body['customers'].each do |org|
      if org['employees'] <= 100
        expect(org['size']).to eq('Small'),
                               "For employee size <=100 we should get size as Small
                               For org - #{org['name']},
                               employee count is #{org['employees']},
                               but got size as #{org['size']}"
      elsif org['employees'] <= 1000
        expect(org['size']).to eq('Medium'),
                               "For employee size <=1000 we should get size as Medium
                               For org - #{org['name']},
                               employee count is #{org['employees']},
                               but got size as #{org['size']}"
      elsif org['employees'] > 1000
        expect(org['size']).to eq('Big'),
                               "For employee size >1000 we should get size as Big
                               For org - #{org['name']},
                               employee count is #{org['employees']},
                               but got size as #{org['size']}"
      end
    end
  end

  shared_examples 'Post request, with name: in the response' do |name|
    it "Post request, with name: #{name} in the request body and validating the size field for the organization",
       :regression, :sanity do |e|
      e.run_step('Raise a post request with name in the request body') do
        api.post('/', { 'name': name })
      end
      e.run_step('Expect status of the response to be 200') do
        expect(api.status).to eq(200)
      end
      e.run_step('Validate the response structure') do
        validate(api.body, { key: 'name', operator: '==', value: name, type: 'string' })
        validate_client_list_response_body
        validate_customer_list_client_structure
      end
      e.run_step('Validate the sorting of the customers list in the response') do
        validate_client_list_sort
      end
      e.run_step('Validate the response headers') do
        validate_client_list_response_header
      end
      e.run_step('Validate the size field with the number of employees in the organization') do
        validate_size_of_org
      end
    end
  end

  context 'Scenarios where name is present in the response' do
    test_data = Libraries::Config.load_test_data('client_library.yml')

    it_behaves_like 'Post request, with name: in the response', test_data['name']
    it_behaves_like 'Post request, with name: in the response', ''
  end

  shared_examples 'Post request, without name: in the response' do |req_body, req_header|
    it "Post request, req_body - #{req_body} & req_header #{req_header}", :regression do |e|
      e.run_step("Raise a post request with body - #{req_body} & header #{req_header}") do
        api.post('/', req_body, req_header)
      end
      e.run_step('Expect status of the response to be 200') do
        expect(api.status).to eq(200)
      end
      e.run_step('Validate the response structure') do
        validate(api.body, { key: 'name', has_key: false })
        validate_client_list_response_body
        validate_customer_list_client_structure
      end
      e.run_step('Validate the sorting of the customers list in the response') do
        validate_client_list_sort
      end
      e.run_step('Validate the response headers') do
        validate_client_list_response_header
      end
    end
  end

  context 'Scenarios where name is not present in the response' do
    it_behaves_like 'Post request, without name: in the response', {},
                    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    it_behaves_like 'Post request, without name: in the response', { 'name': 'test' },
                    { 'Content-Type' => 'text', 'Accept' => 'application/json' }
  end
end

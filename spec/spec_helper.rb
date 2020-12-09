# frozen_string_literal: true

require 'rspec/core'
require 'pry'
require 'yaml'
require 'allure-rspec'
require 'client-api'
Dir['./libraries/*.rb'].sort.each { |file| require file }

Current_run_file_name = Time.now.strftime('%m-%d-%Y_%H:%M:%S')

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'reports/rspec_status/rspec_status.txt'
  config.formatter = AllureRspecFormatter
end

AllureRspec.configure do |config|
  config.results_directory = 'reports/allure'
  config.clean_results_directory = true
end

ClientApi.configure do |config|
  # all these configs are optional;
  config.base_url = Libraries::Config.base_url
  config.headers = Libraries::Config.headers
  config.json_output = { 'Dirname' => './reports/json', 'Filename' => "json_#{Current_run_file_name}" }
  config.time_out = Libraries::Config.timeout
  config.logger = { 'Dirname' => './reports/logs', 'Filename' => "log_#{Current_run_file_name}",
                    'StoreFilesCount' => 2 }
  config.before(:each) do |scenario|
    ClientApi::Request.new(scenario)
  end
end

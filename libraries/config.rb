# frozen_string_literal: true

require 'yaml'

module Libraries
  # All the methods under this config class are class methods
  # This gives us flexibility in fethching the values directly across the framework
  class Config
    # To parse and read the run config files
    # Files will be parsed only once irrespective of any number of method calls
    def self.read_config
      read_config = ENV['run_config'] || 'local.yml'
      @read_config ||= YAML.load_file("#{File.dirname(__FILE__).split('/libraries')[0]}/config/#{read_config}")
    end

    def self.base_url
      Config.read_config
      ENV['base_url'] || @read_config_file['base_url'] || 'No URL is mentioned to run the tests'
    end

    def self.headers
      Config.read_config
      @read_config_file['headers'] || {}
    end

    def self.timeout
      Config.read_config
      @read_config_file['timeout'] || 10
    end

    def self.load_test_data(file_name)
      YAML.load_file("#{File.dirname(__FILE__).split('/libraries')[0]}/test-data/#{file_name}")
    end
  end
end

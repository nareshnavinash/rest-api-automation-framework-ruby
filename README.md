# Rest API automation framework in Ruby

This repo is to have test automation framework for REST API using Ruby. Rubocop and Travis CI integrated.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Made with Ruby](https://img.shields.io/badge/Made%20with-Ruby-red.svg)](https://www.ruby-lang.org/en/)
[![StackOverflow](http://img.shields.io/badge/Stack%20Overflow-Ask-blue.svg)]( https://stackoverflow.com/users/10505289/naresh-sekar)
[![email me](https://img.shields.io/badge/Contact-Email-green.svg)](mailto:nareshnavinash@gmail.com)

## Travis build status 
[![Build Status](https://travis-ci.com/nareshnavinash/rest-api-automation-framework-ruby.svg?branch=main)](https://travis-ci.com/nareshnavinash/rest-api-automation-framework-ruby)

## Prerequsite
* Install RVM 2.7.0 in the machine
* Clone the project to a directory.
* Do `gem install bundler` in the folder path "../selenium-ruby-basic" in commandline
* Give `bundle install`
* Required package will be installed from Gemfile.

## To run the tests
* Now run the test by `rspec`
* Allure report can be get by giving `allure serve reports/allure`
* Logs will be available under `reports/logs`

### Tagged run
* To run the tests based on the tags `rspec --tag sanity` or `rspec --tag regression`
* Its better to have two modes of run within the same tests suite in order to have quicker turn over once the build is deployed

### Parallel run
* To speed up the execution, run the tests in parallel way by trying `parallel_rspec spec/`
* This will split the number of spec files which we have according to the number of cpu cores available in the machine

## Folder Structure Definitions

### Libraries
* Library folder is to have all the common methods that will be used for this project.
* In this sample framework I have config methods to parse and get the run configs.

### Spec
* This folder contains the Tests built with rspec
* Here we can extensively use the Rspec methods and assertions to customize our test run.
* Rspec core documentation - https://rspec.info/documentation/3.9/rspec-core/
* Rspec assertion documentation - https://rspec.info/documentation/3.9/rspec-expectations/
* Rspec mock documentation - https://rspec.info/documentation/3.9/rspec-mocks/

### Test-data
* This folder has all the test data that will be used for this project. 
* Test files can be some upload files, csv, excel, conf, json or even yaml file.
* Here I used YAML file to get the test input data in to the project.
* As a best practice no hardcoding of values inside the project. All the variables has to be mentioned in the test-data folder and fetched inside the project

### Reports
* Reports folder has allure specific result files. These are some xml files which will be used while running `allure serve reports/allure`.
* Results folder also has other form of reports like logs, response json from the api, and rspec_status
* To support CI Integration JUNIT reporting is also integrated with the tests

### Gemfile
* All the dependencies should be mentioned here, so that all the gems can be installed in one shot.
* Its better to specify the gem version for each gems that we use.

### Spec Helper
* Spec helper file will be created inside the Spec foler.
* This file is used to declare all the required gems or folder paths that is needed to run the tests.
* Inside each spec file we need to require only the spec helper file so that each spec is powered to access all the gems or files used within the project.

## Files under root directory

### .rubocop.yml & .rubocop_todo.yml
* These files are used to hold the rubocop configurations specific to this project.
* These files are auto generated after resolving the linter issues
* Currently this project follows all the best practices mentioned by rubocop except `Metrics/BlockLength <= 25`

### .travis.yml
* Integrated with travis for CI to validate the linter errors using rubocop upon raising PR

## Built With

* [Rspec](https://rubygems.org/gems/rspec/versions/3.4.0) - Test core framework
* [Allure Rspec](https://rubygems.org/gems/allure-rspec) - For Detailed reporting.
* [Client-api](https://github.com/nareshnavinash/client-api) - For raising API requests

## Authors

* **[Naresh Sekar](https://github.com/nareshnavinash)**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* To all the open source contributors whose code has been referred to create this framework

*Happy Automating*

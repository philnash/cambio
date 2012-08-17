require File.expand_path('../../spec_helper', __FILE__)

describe Cambio::Configuration do
  before do
    @configuration = Cambio::Configuration.new
  end

  it 'should default to the http url' do
    @configuration.endpoint.must_equal 'http://openexchangerates.org/api/'
  end

  it 'should default to no app id' do
    @configuration.app_id.must_be_nil
  end

  describe 'setting the endpoint' do
    before do
      @configuration.endpoint = 'https://openexchangerates.org/api/'
    end

    it 'should update the endpoint' do
      @configuration.endpoint.must_equal 'https://openexchangerates.org/api/'
    end
  end

  describe 'setting the app_id' do
    before do
      @configuration.app_id = 'abc123'
    end

    it 'should set the app_id' do
      @configuration.app_id.must_equal 'abc123'
    end
  end

  describe 'resetting the configuration' do
    before do
      @configuration.app_id = 'abc123'
      @configuration.endpoint = 'https://openexchangerates.org/api/'
      @configuration.reset
    end

    it 'should reset the app_id to default' do
      @configuration.app_id.must_be_nil
    end

    it 'should reset the endpoint to default' do
      @configuration.endpoint.must_equal 'http://openexchangerates.org/api/'
    end
  end
end
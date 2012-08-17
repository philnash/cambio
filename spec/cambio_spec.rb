require File.expand_path('../spec_helper', __FILE__)

describe Cambio do
  describe 'when configuring with an api key' do
    before do
      Cambio.configure do |config|
        config.app_id = 'bcc1d1ad9f4d4dd69b12a64c913857fe'
      end
    end

    after do
      Cambio.configuration.reset
    end

    it 'should be configured with an api key' do
      Cambio.configuration.app_id.must_equal 'bcc1d1ad9f4d4dd69b12a64c913857fe'
    end

    it 'should be configured with an endpoint' do
      Cambio.configuration.endpoint.must_equal 'http://openexchangerates.org/api/'
    end

    it 'should have a configuration object' do
      Cambio.configuration.must_be_instance_of Cambio::Configuration
    end

    describe 'accessing the api' do
      describe 'when getting the latest rates' do
        before do
          VCR.use_cassette 'latest' do
            @latest = Cambio.latest
          end
        end

        it 'should return a hashie' do
          @latest.must_be_instance_of Hashie::Mash
        end

        [:disclaimer, :license, :timestamp, :base, :rates].each do |field|
          it "should have the #{field}" do
            @latest.must_respond_to(field)
          end
        end
      end

      describe 'when getting historical rates' do
        describe 'with an object that responds to strftime' do
          before do
            @date = Time.at(1344896438)
            VCR.use_cassette 'historical_date' do
              @historical = Cambio.historical(@date)
            end
          end

          it 'should return a hashie' do
            @historical.must_be_instance_of Hashie::Mash
          end

          [:disclaimer, :license, :timestamp, :base, :rates].each do |field|
            it "should have the #{field}" do
              @historical.must_respond_to(field)
            end
          end

          it 'must rause a not found error when the year doesn\'t exist' do
            lambda {
              VCR.use_cassette 'historical_missing' do
                Cambio.historical('00000')
              end
            }.must_raise Cambio::NotFoundError
          end
        end

        describe 'with a date string' do
          before do
            VCR.use_cassette 'historical_string' do
              @historical = Cambio.historical('2011-02-01')
            end
          end

          it 'should return a hashie' do
            @historical.must_be_instance_of Hashie::Mash
          end

          [:disclaimer, :license, :timestamp, :base, :rates].each do |field|
            it "should have the #{field}" do
              @historical.must_respond_to(field)
            end
          end
        end
      end

      describe 'when getting the currencies' do
        before do
          VCR.use_cassette 'currencies' do
            @currencies = Cambio.currencies
          end
        end

        it 'should return a hashie' do
          @currencies.must_be_instance_of Hashie::Mash
        end

        it 'should  return a USD' do
          @currencies['USD'].must_equal "United States Dollar"
        end
      end

      describe 'when getting raw results' do
        describe 'for the latest rates' do
          before do
            VCR.use_cassette 'latest' do
              @latest = Cambio.latest(:raw => true)
            end
          end

          it 'should return a JSON string' do
            @latest.must_be_instance_of String
          end
        end

        describe 'for historical rates' do
          describe 'with a date object' do
            before do
              @date = Time.at(1344896438)
              VCR.use_cassette 'historical_date' do
                @historical = Cambio.historical(@date, :raw => true)
              end
            end

            it 'should return a string' do
              @historical.must_be_instance_of String
            end
          end

          describe 'with a date string' do
            before do
              VCR.use_cassette 'historical_string' do
                @historical = Cambio.historical('2011-02-01', :raw => true)
              end
            end

            it 'should return a string' do
              @historical.must_be_instance_of String
            end
          end
        end

        describe 'for the currencies' do
          before do
            VCR.use_cassette 'currencies' do
              @currencies = Cambio.currencies(:raw => true)
            end
          end

          it 'should return a JSON string' do
            @currencies.must_be_instance_of String
          end
        end
      end
    end
  end

  describe 'when using with an incorrect api key' do
    before do
      Cambio.configure { |c| c.app_id = 'wrong' }
    end

    it 'must raise an error for latest' do
      lambda {
        VCR.use_cassette 'latest_unauth' do
          Cambio.latest
        end
      }.must_raise Cambio::UnauthorisedError
    end
    it 'must raise an error for currencies' do
      lambda {
        VCR.use_cassette 'currencies_unauth' do
          Cambio.currencies
        end
      }.must_raise Cambio::UnauthorisedError
    end
    it 'must raise an error for currencies' do
      lambda {
        VCR.use_cassette 'historical_unauth' do
          Cambio.historical('2011-02-01')
        end
      }.must_raise Cambio::UnauthorisedError
    end

    after do
      Cambio.configuration.reset
    end
  end
end
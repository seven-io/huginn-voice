require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::Sms77VoiceAgent do
  is_live_test = nil != ENV["SMS77_LIVE_TEST"]
  api_key = is_live_test ? ENV["SMS77_API_KEY"] : 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  to = is_live_test ? ENV["SMS77_RECIPIENT"] : '+4900000000000'

  before do
    @default_options = {
      api_key: api_key,
      text: 'Hope to see you again soon!',
      to: to,
    }

    if is_live_test
      require 'vcr'

      VCR.configure do |c|
        c.allow_http_connections_when_no_cassette = true

        c.hook_into :webmock
      end

      WebMock.allow_net_connect!
    end

    @checker = Agents::Sms77Agent.new name: 'Sms77VoiceAgentTest', options: @default_options
    @checker.user = users(:bob)
    @checker.save!

    @event = Event.new
    @event.agent = agents(:bob_manual_event_agent)
    @event.payload = @default_options
    @event.save!
  end

  describe 'validation' do
    before do
      expect(@checker).to be_valid
    end

    it "should validate the presence of api_key" do
      @checker.options[:api_key] = ''
      expect(@checker).not_to be_valid
    end

    it "should validate the presence of to" do
      @checker.options[:to] = ''
      expect(@checker).not_to be_valid
    end

    it "should validate the presence of text" do
      @checker.options[:text] = ''
      expect(@checker).not_to be_valid
    end
  end

  describe '#receive' do
    it "should receive event" do
      stub(HTTParty).post {
        '100'\
        '174206'\
        '0.1'
      }
      @checker.receive([@event])
    end

    it "should raise error on wrong credentials" do
      unless is_live_test
        stub(HTTParty).post { { "success" => "900" } }
      end
      opts = @default_options
      opts[:api_key] = 'thisAintGonnaWork!'
      expect { @checker.send_voice(opts.stringify_keys) }.to raise_error(StandardError, /SMS77_AUTH_ERROR:/)
    end

    it "should raise error on general dispatch error" do
      unless is_live_test
        stub(HTTParty).post { { "success" => "202" } }
      end
      opts = @default_options
      opts[:to] = '0'
      expect { @checker.send_voice(opts.stringify_keys) }.to raise_error(StandardError, /SMS77_DISPATCH_ERROR:/)
    end

    it "should WORK!" do
      unless is_live_test
        stub(HTTParty).post { "100" }
      end

      expect(@checker.send_voice(@default_options.stringify_keys)).to eq(100)
    end
  end
end
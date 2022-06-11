require 'net/http'

module Agents
  class Sms77VoiceAgent < Agent
    include ActiveModel::Type
    include FormConfigurable

    cannot_be_scheduled!
    cannot_create_events!
    no_bulk_receive!

    description <<-MD
      The Sms77.io Agent receives and collects events for dispatching Text2Voice phone calls to a given number.

      Expects an event with key `text`, `message`, `voice` or `sms` with the text to send. Use the `EventFormattingAgent` if lacks such a key.

      Requires an API key from [Sms77](https://sms77.io) for sending.

      Options:

      * `text` - The message you want to send *(required)*

      * `to` - recipient phone number *(required)*

      * `from` - Sender number. *Expects a string with 11 alphanumeric or 16 numeric characters*

      * `xml` - Decides whether the given text is XML or not *Allowed values: 0, 1*

      * `debug` - Validate request parameters but don't actually make a call *Allowed values: 0, 1*
    MD

    def required_options
      {
        'api_key' => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        'text' => 'Hope to see you again soon!',
        'to' => '+4900000000000'
      }
    end

    def optional_options
      {
        'debug' => false,
        'from' => '',
        'xml' => false
      }
    end

    def default_options
      optional_options.merge(required_options)
    end

    form_configurable :api_key, type: :text
    form_configurable :debug, type: :boolean
    form_configurable :from, type: :text
    form_configurable :text, type: :text
    form_configurable :to, type: :text
    form_configurable :xml, type: :boolean

    def source_keys
      %w[text message voice sms]
    end

    def validate_options
      required_options.keys.each do |k|
        val = options[k]
        errors.add(:base, "#{k} is required") if val.nil? || val.empty?
      end
    end

    def working?
      interpolated['api_key'].present? && !recent_error_logs?
    end

    def receive(incoming_events)
      interpolate_with_each(incoming_events) do |event|

        source_keys.each do |k|
          text = event.payload[k].presence.to_s

          next unless text.present?

          send_voice text
        end
      end
    end

    def send_voice(text)
      fd = default_options

      fd.delete('api_key')

      fd.keys.each do |k|
        val = interpolated[k]

        if 'xml' === k or 'debug' === k
          val = ActiveModel::Type::Boolean.new.cast(val) ? '1' : '0'
        end

        fd[k] = val
      end

      fd['text'] = text

      log "Sending Text2Speech with payload #{fd.to_json}"

      body = HTTParty.post('https://gateway.sms77.io/api/voice', :body => fd, :headers => {
        'Authorization' => "Basic #{interpolated['api_key']}",
        'sentWith' => "Huginn"
      })

      code = body.split(/\n+/)[0].to_i

      if code === 100
        log body
      elsif code === 900
        raise StandardError, "SMS77_AUTH_ERROR: #{body}"
      else
        raise StandardError, "SMS77_DISPATCH_ERROR: #{body}"
      end

      body
    end
  end
end

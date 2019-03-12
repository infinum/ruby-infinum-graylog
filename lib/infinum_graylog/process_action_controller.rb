module InfinumGraylog
  class ProcessActionController
    TYPE = :request

    attr_reader :event

    def initialize(event)
      @event = event
    end

    def format
      return unless configuration.types.include?(TYPE)
      return if configuration.skip_statuses.include?(event_status)

      {
        short_message: event_name,
        type: :request,
        duration: event.duration,
        application: configuration.application,
        status: event_status,
        headers: headers
      }.reverse_merge(cleaned_payload)
    end

    private

    def event_name
      "#{event.payload[:controller]}##{event.payload[:action]}" || 'Action Controller'
    end

    def event_status
      return event.payload[:status] if event.payload[:status].present?
      return 0 if event.payload[:exception].blank?

      ActionDispatch::ExceptionWrapper.status_code_for_exception(event.payload[:exception].first)
    end

    def cleaned_payload
      Cleaner.new(nil).clean_object(event.payload)
    end

    def headers
      return nil unless event.payload[:headers]

      headers = {}

      event.payload[:headers].each do |key, value|
        if key.to_s.start_with?('HTTP_')
          header_key = key[5..-1]
        elsif %w[CONTENT_TYPE CONTENT_LENGTH].include?(key)
          header_key = key
        else
          next
        end

        headers[header_key.split('_').map(&:capitalize).join('-')] = value
      end

      headers
    end

    def configuration
      InfinumGraylog.configuration
    end
  end
end

module InfinumGraylog
  class ProcessActionController
    attr_reader :event

    def initialize(event)
      @event = event
    end

    def format
      return if configuration.skip_statuses.include?(event_status)

      {
        short_message: event_name,
        type: 'action_controller',
        request_id: event.transaction_id,
        duration: event.duration,
        application: configuration.application,
        status: event_status
      }.reverse_merge(event.payload)
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

    def configuration
      InfinumGraylog.configuration
    end
  end
end

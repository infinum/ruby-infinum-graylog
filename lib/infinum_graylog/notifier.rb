module InfinumGraylog
  class Notifier
    include Singleton

    def initialize
      @notifier = GELF::Notifier.new(configuration.host, configuration.port, 'WAN', options)
      @notifier.collect_file_and_line = false
    end

    def notify(payload)
      payload = payload.merge(request_id: request_id)
      Thread.new { @notifier.notify!(payload) }.join
    end

    def thread_key
      @thread_key ||= "infinum_graylog_notifier:#{object_id}"
    end

    def self.notify(payload)
      return if payload.blank?

      instance.notify(payload)
    end

    def self.request_id=(request_id)
      Thread.current[instance.thread_key] = request_id
    end

    private

    def options
      {
        protocol: configuration.protocol,
        level: configuration.level
      }.merge(configuration.options)
    end

    def configuration
      @configuration ||= InfinumGraylog.configuration
    end

    def request_id
      Thread.current[thread_key] || SecureRandom.hex
    end
  end
end

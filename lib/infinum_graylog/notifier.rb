module InfinumGraylog
  class Notifier
    include Singleton

    def initialize
      @notifier = GELF::Notifier.new(configuration.host, configuration.port, 'WAN', options)
      @notifier.collect_file_and_line = false
    end

    def notify(payload)
      @notifier.notify!(payload)
    end

    def self.notify(payload)
      return unless payload.present?
      instance.notify(payload)
    end

    private

    def options
      {
        protocol: configuration.protocol,
        level: configuration.level,
      }.merge(configuration.options)
    end

    def configuration
      InfinumGraylog.configuration
    end
  end
end


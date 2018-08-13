module InfinumGraylog
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :application, :protocol, :level, :options, :host, :port, :skip_environments
    attr_accessor :skip_statuses

    def initialize
      @application = "#{Rails.application.class.parent_name.underscore}-#{Rails.env}"
      @protocol = GELF::Protocol::TCP
      @level = GELF::Levels::INFO
      @options = {
        tls: {
          cert: '/etc/ssl/private/graylog/graylog.crt',
          key: '/etc/ssl/private/graylog/graylog.key'
        }
      }
      @host = 'dreznik.infinum.co'
      @port = 12201 # rubocop:disable NumericLiterals
      @skip_environments = ['development', 'test']
      @skip_statuses = [404, 500]
    end
  end
end

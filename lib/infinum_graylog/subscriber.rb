module InfinumGraylog
  class Subscriber
    def self.subscribe
      return unless tls_and_files_exist?
      return if InfinumGraylog.configuration.skip_environments.include?(Rails.env)

      puts '[InfinumGraylog] notifications configured'

      ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        Notifier.notify(ProcessActionController.new(event).format)
      end

      ActiveSupport::Notifications.subscribe 'sql.active_record' do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        Notifier.notify(SqlActiveRecord.new(event).format)
      end
    end

    def self.tls_and_files_exist?
      tls_configuration = InfinumGraylog.configuration.options[:tls]

      tls_configuration.present? &&
        File.exist?(tls_configuration[:cert]) && File.exist?(tls_configuration[:key])
    end
  end
end

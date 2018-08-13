module InfinumGraylog
  class Subscriber
    def self.subscribe
      unless InfinumGraylog.configuration.skip_environments.include?(Rails.env)
        ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          Notifier.notify(ProcessActionController.new(event).format)
        end

        ActiveSupport::Notifications.subscribe 'sql.active_record' do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          Notifier.notify(SqlActiveRecord.new(event).format)
        end
      end
    end
  end
end

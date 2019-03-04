module InfinumGraylog
  class Subscriber
    def self.subscribe
      return unless InfinumGraylog.can_subscribe?

      puts '[InfinumGraylog] notifications configured'

      ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        Notifier.notify(ProcessActionController.new(event).format)
      end

      ActiveSupport::Notifications.subscribe 'sql.active_record' do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        Notifier.notify(SqlActiveRecord.new(event, caller).format)
      end

      yield if block_given?
    end
  end
end

module InfinumGraylog
  class SqlActiveRecord
    SKIPPABLE_ACTIONS = ['SCHEMA', 'ActiveRecord::SchemaMigration Load', 'CACHE']

    attr_reader :event, :trace

    def initialize(event, trace)
      @event = event
      @trace = trace
    end

    def format
      return if event.payload[:statement_name].nil? && event.payload[:name].nil?
      return if skippable_actions.include?(event_name)

      {
        short_message: event_name,
        sql: sql,
        type: 'sql',
        duration: event.duration,
        application: configuration.application,
        trace: Rails.backtrace_cleaner.clean(trace)
      }
    end

    private

    def event_name
      event.payload[:name] || 'SQL'
    end

    def sql
      sql = event.payload[:sql].dup

      binds = event.payload[:binds]
      if binds.present?
        binds = binds.map { |_col, val| val.inspect }
        binds.each { |b| sql.sub!(/\$./, b) }
      end

      sql
    end

    def skippable_actions
      SKIPPABLE_ACTIONS + configuration.skippable_sql_actions
    end

    def configuration
      InfinumGraylog.configuration
    end
  end
end

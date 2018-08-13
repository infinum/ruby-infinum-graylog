module InfinumGraylog
  class SqlActiveRecord
    SKIPPABLE_ACTIONS = ['SCHEMA', 'ActiveRecord::SchemaMigration Load', 'CACHE']

    attr_reader :event

    def initialize(event)
      @event = event
    end

    def format
      return if event.payload[:statement_name].nil? && event.payload[:name].nil?
      return if SKIPPABLE_ACTIONS.include?(event_name)

      {
        short_message: event_name,
        sql: sql,
        type: 'sql',
        request_id: event.transaction_id,
        duration: event.duration,
        application: 'tvornica-snova-development'
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
  end
end

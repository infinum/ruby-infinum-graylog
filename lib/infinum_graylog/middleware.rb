module InfinumGraylog
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      if InfinumGraylog.can_subscribe?
        InfinumGraylog::Notifier.request_id = request.uuid
      end
      @app.call(env)
    end
  end
end

module InfinumGraylog
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      InfinumGraylog::Notifier.request_id = request.uuid
      @app.call(env)
    end
  end
end

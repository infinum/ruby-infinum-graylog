module InfinumGraylog
  class Railtie < ::Rails::Railtie
    initializer 'infinum_graylog.insert_middleware' do |app|
      app.config.middleware.insert_after ActionDispatch::RequestId, InfinumGraylog::Middleware
    end
  end
end

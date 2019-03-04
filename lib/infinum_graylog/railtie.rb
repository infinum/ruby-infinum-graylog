module InfinumGraylog
  class Railtie < ::Rails::Railtie
    initializer 'infinum_graylog.insert_middleware' do |app|
      if ActionDispatch.const_defined? :RequestId
        app.config.middleware.insert_after ActionDispatch::RequestId, InfinumGraylog::Middleware
      else
        app.config.middleware.insert_after Rack::MethodOverride, InfinumGraylog::Middleware
      end
    end

  end
end

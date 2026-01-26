Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # In production, specify your Flutter app domain

    resource '/api/*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['X-Page', 'X-Total-Pages', 'X-Total-Count']
  end
end

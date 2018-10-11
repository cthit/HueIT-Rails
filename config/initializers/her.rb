Her::API.setup url: Rails.configuration.account_ip do |c|
  # Request
  c.use AccountTokenAuth
  c.use Faraday::Request::UrlEncoded

  # Response
  c.use Her::Middleware::DefaultParseJSON

  # Adapter
  c.use Faraday::Adapter::NetHttp
end

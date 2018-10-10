class AccountTokenAuth < Faraday::Middleware
  def call(env)
  	token = RequestStore.store[:account_token]
    env[:request_headers]["Authorization"] = "Bearer #{token}"

    strip_last_slash_and_add_dot_json(env[:url])

    @app.call(env)
  end

  private
  def strip_last_slash_and_add_dot_json(url)
	if url.path.last == '/'
    	url.path = url.path[0, url.path.length - 1]
    end
    url.path += '.json'
  end
end

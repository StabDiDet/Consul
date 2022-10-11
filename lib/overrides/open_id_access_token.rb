module OpenIDConnect
  class AccessToken < Rack::OAuth2::AccessToken::Bearer
    private

    def resource_request
      res = yield
      case res.status
      when 200
        parsed_hash =
          if res.body.start_with?("{", "[") && res.body.end_with?("}", "]")
            JSON.parse(res.body)
          else
            JSON::JWT.decode(res.body, :skip_verification)
          end

        parsed_hash.with_indifferent_access
      when 400
        raise BadRequest.new("API Access Faild", res)
      when 401
        raise Unauthorized.new("Access Token Invalid or Expired", res)
      when 403
        raise Forbidden.new("Insufficient Scope", res)
      else
        raise HttpError.new(res.status, "Unknown HttpError", res)
      end
    end
  end
end


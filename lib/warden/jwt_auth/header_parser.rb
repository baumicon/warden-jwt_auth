# frozen_string_literal: true

module Warden
  module JWTAuth
    # Helpers to parse token from a request and to a response
    module HeaderParser
      # Method for `X-Authorization` header. Token is present in request/response
      # headers as `Bearer %token%`
      METHOD = 'Bearer'

      # Parses the token from a rack request
      #
      # @param env [Hash] rack env hash
      # @return [String] JWT token
      # @return [nil] if token is not present
      def self.from_env(env)
        auth = env['HTTP_X_AUTHORIZATION']
        return nil unless auth
        method, token = auth.split
        method == METHOD ? token : nil
      end

      # Returns a copy of `env` with token added to the `HTTP_X_AUTHORIZATION`
      # header. Be aware than `env` is not modified in place.
      #
      # @param env [Hash] rack env hash
      # @param token [String] JWT token
      # @return [Hash] modified rack env
      def self.to_env(env, token)
        env = env.dup
        env['HTTP_X_AUTHORIZATION'] = "#{METHOD} #{token}"
        env
      end

      # Returns a copy of headers with token added in the `X-Authorization` key.
      # Be aware that headers is not modified in place
      #
      # @param headers [Hash] rack hash response headers
      # @param token [String] JWT token
      # @return [Hash] response headers with the token added
      def self.to_headers(headers, token)
        headers = headers.dup
        headers['X-Authorization'] = "#{METHOD} #{token}"
        headers
      end
    end
  end
end

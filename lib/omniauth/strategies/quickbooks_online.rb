require 'omniauth-oauth2'
require 'jwt'

module OmniAuth
  module Strategies
    class QuickbooksOnline < OmniAuth::Strategies::OAuth2
      module Defaults
        ACCOUNTS_DOMAIN = 'accounts.platform.intuit.com/v1/openid_connect/userinfo'.freeze
      end

      option :name, :quickbooks_online

      option(
        :client_options,
        {
          site: 'https://appcenter.intuit.com/connect/oauth2',
          authorize_url: 'https://appcenter.intuit.com/connect/oauth2',
          token_url: 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer',
        },
      )

      uid { decoded_id_token['sub'] }

      info do
        parsed_body
      end

      extra do
        { 
          claims: decoded_id_token,
          scope: options.scope
        }
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      private

      delegate :params, to: :access_token
      delegate :id_token, to: :params

      def decoded_id_token
        JWT.decode(id_token, options.client_secret, false, { algorithm: 'RS256' })&.first
      end

      def parsed_name
        "#{info['givenName']} #{info['familyName']}"
      end

      def auth_hash
        super.tap do |auth|
          auth.info.name = parsed_name
        end
      end

      def parsed_body
        @_parsed_body ||= JSON.parse api_response
      end

      def api_response
        access_token.get("https://#{ Defaults::ACCOUNTS_DOMAIN }").body
      end
    end
  end
end

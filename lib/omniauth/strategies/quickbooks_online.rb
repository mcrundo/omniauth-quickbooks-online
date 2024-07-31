require 'omniauth-oauth2'

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

      uid { info['sub'] }

      name { name_string }

      info do
        parsed_body
      end

      extra do
        { 
          realm_id: request.params['realmId'] 
        }
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      private

      def name_string
        "#{given_name} #{family_name}"
      end

      # first_name
      def given_name
        info['givenName'] ? info['givenName']&.titlecase : "-"
      end

      # last_name
      def family_name
        info['familyName'] ? info['familyName']&.titlecase : "-"
      end

      def parsed_body
        JSON.parse api_response
      end

      def api_response
        @_api_response ||= access_token.get("https://#{ Defaults::ACCOUNTS_DOMAIN }").body
      end
    end
  end
end

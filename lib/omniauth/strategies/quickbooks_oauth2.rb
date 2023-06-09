require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class QuickbooksOauth2 < OmniAuth::Strategies::OAuth2
      option :name, :quickbooks_oauth2

      option(
        :client_options,
        {
          site: 'https://appcenter.intuit.com/connect/oauth2',
          authorize_url: 'https://appcenter.intuit.com/connect/oauth2',
          token_url: 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer',
        },
      )

      uid { request.params['realmId'] }

      info do
        raw_info
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= options.scope.split(/\s+/).include?('openid') ?
          JSON.parse(access_token.get("https://#{accounts_domain}/v1/openid_connect/userinfo").body) :
          {}
      end

      def callback_url
        "https://9734-2601-152-c00-1880-9d2a-2a5-629e-4bb6.ngrok.io/quickbooks/oauth2-redirect"
      
      end

      private

      def accounts_domain
        false == options.sandbox ? 'accounts.platform.intuit.com' : 'sandbox-accounts.platform.intuit.com'
      end
    end
  end
end

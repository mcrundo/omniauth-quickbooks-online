require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class QuickbooksOnline < OmniAuth::Strategies::OAuth2
      module Defaults
        ACCOUNTS_DOMAIN = 'accounts.platform.intuit.com'.freeze
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

      uid { request.params['realmId'] }

      info do
        raw_info
      end

      extra do
        { raw_info: raw_info }
      end

      def callback_url
        options[:redirect_uri] || full_host + script_name + callback_path
      end

      def raw_info
        @raw_info ||= raw_info_valid? ? parsed_body : {}
      end

      private

      def parsed_body
        JSON.parse(access_token.get("https://#{ Defaults::ACCOUNTS_DOMAIN }/v1/openid_connect/userinfo").body)
      end

      def raw_info_valid?
        split_options_scope.include?('openid')
      end

      def split_options_scope
        options_scope.split(/\s+/)
      end

      def options_scope
        options.scope
      end
    end
  end
end

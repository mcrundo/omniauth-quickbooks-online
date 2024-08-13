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

      uid { raw_info['sub'] }

      info do
        raw_info
      end

      extra do
        { 
          claims: decoded_id_token,
          provider_scope: provider_scope,
          realm_id: realm_id,
          scope: state_hash['scope']
        }
      end

      def callback_url
        full_host + callback_path
      end

      def auth_hash
        super.tap do |auth|
          auth.info.first_name = raw_info['givenName']
          auth.info.last_name = raw_info['familyName']
        end
      end

      def raw_info
        @_raw_info ||= access_token.get("https://#{ Defaults::ACCOUNTS_DOMAIN }").parsed
      end

      private

      delegate :params, to: :access_token

      def decoded_id_token
        @decoded_id_token = JWT.decode(params.id_token, options.client_secret, false, { algorithm: 'RS256' })&.first
      end

      def provider_scope
        return nil if state_hash['provider_scope'].empty?
        state_hash['provider_scope']
      end

      def realm_id
        @realm_id = Integer request.params['realmId'] rescue nil
      end

      def state_hash
        @state_hash = URI.decode_www_form(request.params['state']).to_h
      end
    end
  end
end

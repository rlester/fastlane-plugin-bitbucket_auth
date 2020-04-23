require 'fastlane/action'
require 'fastlane_core/ui/ui'
require 'net/http'
require 'uri'
require 'json'
require_relative '../helper/bitbucket_auth_helper'

module Fastlane
  module Actions
    module SharedValues
      BITBUCKET_ACCESS_TOKEN = :BITBUCKET_ACCESS_TOKEN
    end

    class BitbucketAuthAction < Action
      def self.run(params)
        bitbucket_oauth_key = params[:bitbucket_oauth_key]
        bitbucket_oauth_secret = params[:bitbucket_oauth_secret]

        uri = URI.parse("https://bitbucket.org/site/oauth2/access_token")
        request = Net::HTTP::Post.new(uri)
        request.basic_auth(bitbucket_oauth_key, bitbucket_oauth_secret)
        request.set_form_data(
            "grant_type" => "client_credentials",
        )

        req_options = {
            use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end

        unless response.is_a?(Net::HTTPSuccess)
          UI.user_error!("Code: #{response.code} - Message: #{response.message}")
        end

        parsed_json = JSON.parse(response.body)
        access_token = parsed_json["access_token"]

        Actions.lane_context[SharedValues::BITBUCKET_ACCESS_TOKEN] = access_token
        return access_token
      end

      def self.description
        "Generate a OAuth Token for Bitbucket API Access."
      end

      def self.authors
        ["rlester"]
      end

      def self.return_value
        "Bitbucket OAuth token string."
      end

      def self.output
        [
            'BITBUCKET_ACCESS_TOKEN', 'Generated access token for bitbucket api.'
        ]
      end

      def self.details
        '
         To get started generate an OAuth Secrect and key by visting "Workspace settings" then "OAuth consumers" at: \n
         https://bitbucket.org/<username>/workspace/settings/api. \n
         The consumer must be marked "This is a private consumer". \n
         The minimum permissions required are "Repositories" "Read". \n
         Note: "Callback URL" must have a value, it can be anything (http://localhost) but it must exist.
        '
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(key: :bitbucket_oauth_key,
                                         env_name: "BITBUCKET_OAUTH_KEY",
                                         description: "A bitbucket oauth key",
                                         optional: false,
                                         type: String),

            FastlaneCore::ConfigItem.new(key: :bitbucket_oauth_secret,
                                         env_name: "BITBUCKET_OAUTH_SECRET",
                                         description: "A bitbucket oauth secret",
                                         optional: false,
                                         type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end

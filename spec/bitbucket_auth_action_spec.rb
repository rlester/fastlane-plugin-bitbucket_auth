describe Fastlane::Actions::BitbucketAuthAction do
  describe '#run' do
    after :each do
      Fastlane::FastFile.new.parse("lane :test do
        Actions.lane_context[SharedValues::BITBUCKET_ACCESS_TOKEN] = nil
      end").runner.execute(:test)
    end

    it "raises an error if no bitbucket oauth secret was given" do
      expect do
        Fastlane::FastFile.new.parse("
        lane :test do
          bitbucket_auth(
            bitbucket_oauth_key: 'abc123'
          )
        end").runner.execute(:test)
      end.to raise_error("No value found for 'bitbucket_oauth_secret'")
    end

    it "raises an error if no bitbucket oauth key was given" do
      expect do
        Fastlane::FastFile.new.parse("
        lane :test do
          bitbucket_auth(
            bitbucket_oauth_secret: 'abc123'
          )
        end").runner.execute(:test)
      end.to raise_error("No value found for 'bitbucket_oauth_key'")
    end

    context "with bitbucket key and bitbucket secret" do
      before(:each) do
        stub_success_fetch_token
      end

      it "succeeds with variables given through invocation." do
        returned_token = Fastlane::FastFile.new.parse("
          lane :test do
            bitbucket_auth(
              bitbucket_oauth_key: 'abc123',
              bitbucket_oauth_secret: 'abc123'
            )
          end").runner.execute(:test)
        expect(!returned_token.nil?)
        expect(!ENV["BITBUCKET_ACCESS_TOKEN"].nil?)
      end

      it "succeeds with variables given through environment." do
        ENV['BITBUCKET_OAUTH_SECRET'] = "abc123"
        ENV['BITBUCKET_OAUTH_KEY'] = "abc123"

        returned_token = Fastlane::FastFile.new.parse("
        lane :test do
          bitbucket_auth()
        end").runner.execute(:test)
        expect(!returned_token.nil?)
        expect(!ENV["BITBUCKET_ACCESS_TOKEN"].nil?)
      end
    end

    it "supports all platforms" do
      expect(Fastlane::Actions::BitbucketAuthAction.is_supported?(:ios)).to be(true)
      expect(Fastlane::Actions::BitbucketAuthAction.is_supported?(:android)).to be(true)
      expect(Fastlane::Actions::BitbucketAuthAction.is_supported?(:mac)).to be(true)
    end
  end
end

def stub_success_fetch_token
  stub_request(:post, "https://bitbucket.org/site/oauth2/access_token").
    with(
      body: { "grant_type" => "client_credentials" },
      headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Basic YWJjMTIzOmFiYzEyMw==',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Host' => 'bitbucket.org',
          'User-Agent' => 'Ruby'
      }
    ).
    to_return(status: 200, body: '{
                                      "access_token": "apwiodfhjioawhfoiaw230-219-38nsd92ui3ijnaiodj0-92u3uhgaiudhbaiou=",
                                      "scopes": "pullrequest:write snippet:write",
                                      "expires_in": 7200,
                                      "refresh_token": "qTFePHfcs9NbSK4PP9",
                                      "token_type": "bearer"
                                    }',
                headers: {})
end

def sub_failed_fetch_token
  stub_request(:post, "https://bitbucket.org/site/oauth2/access_token").
    with(
      body: { "grant_type" => "client_credentials" },
      headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Basic YWJjMTIzOmFiYzEyMw==',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Host' => 'bitbucket.org',
          'User-Agent' => 'Ruby'
      }
    ).
    to_return(status: 400, body: '', headers: {})
end

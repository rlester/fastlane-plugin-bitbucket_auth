# Bitbucket Auth plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-bitbucket_auth)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-bitbucket_auth`, add it to your project by running:

```bash
fastlane add_plugin bitbucket_auth
```

## About Bitbucket Auth 

Generate an OAuth Token for Bitbucket API Access.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

 To get started generate an OAuth Secrect and key by visting "Workspace settings" then "OAuth consumers" at: https://bitbucket.org/<username>/workspace/settings/api.

 - The consumer must be marked "This is a private consumer". 
 - The minimum permissions required are "Repositories" "Read".
 
 *Note:* "Callback URL" must have a value, it can be anything (http://localhost) but it must exist.
       

```
    bitbucket_auth(
      bitbucket_oauth_key: <Bitbucket OAuth Key>,
      bitbucket_oauth_secret: <Bitbucket OAuth Secret>>
    )
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

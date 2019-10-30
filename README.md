# Intercom

An Elixir library for working with [Intercom](https://intercom.io) using the [Intercom API](https://developers.intercom.com/building-apps/docs/rest-apis).

## Installation

Add `intercom` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:intercom, "~> 1.0.0"}
  ]
end
```

## Configuration

To get started you'll need to add your [access_token](https://developers.intercom.com/building-apps/docs/authentication-types#section-access-tokens) to your `config.exs` file.

See [How to get your Access Token](https://developers.intercom.com/building-apps/docs/authentication-types#section-how-to-get-your-access-token).

**Keep your access token secret. It provides access to your private Intercom data and should be treated like a password.**

```elixir
config :intercom,
  access_token: "access_token_here..."
```

## Usage

TODO: Generate documentation with [ex_doc](https://github.com/elixir-lang/ex_doc), publish to hexdocs.pm and reference here.

## Resources

- [Intercom Developer Hub](https://developers.intercom.com/)
- [API Guide](https://developers.intercom.com/building-apps/docs/rest-apis)
- [API Reference](https://developers.intercom.com/intercom-api-reference/reference)
- [SDKs and Plugins](https://developers.intercom.com/building-apps/docs/sdks-plugins)

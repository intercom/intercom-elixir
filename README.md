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

This library provides functions for easy access to API endpoints. For example, [User](https://developers.intercom.com/intercom-api-reference/reference#users) endpoints can be accessed like this:

```elixir
# Get a user
{:ok, user} = Intercom.Users.get("a1b2")

# List users by `tag_id`
{:ok, %{"users" => users}} = Intercom.Users.list_by(tag_id: "a1b2")

# Insert or update a user
{:ok, upserted_user} = Intercom.Users.upsert(%{id: "a1b2", name: "Steve Buscemi"})
```

If there are endpoints in the API that aren't currently supported by this library, you can access them manually like this:

```elixir
{:ok, data} = Intercom.API.call_endpoint(:post, "new_endpoint/a1b2", %{body_data: "here"})
```

## Resources

- [Intercom Developer Hub](https://developers.intercom.com/)
- [API Guide](https://developers.intercom.com/building-apps/docs/rest-apis)
- [API Reference](https://developers.intercom.com/intercom-api-reference/reference)
- [SDKs and Plugins](https://developers.intercom.com/building-apps/docs/sdks-plugins)

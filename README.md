# mfpb

mfpb is a simple tool used to inspect HTTP requests.

It tries not to get in your way, it doesn't parse the body or do other
fancy stuff with your request. This way you see exactly what was sent.
The idea is basically having the same output you would get by doing HTTP
requests to a listening instance of `netcat`.

Under the hood it uses the super cool [Phoenix Live View](https://github.com/phoenixframework/phoenix_live_view),
so new requests are prepended at the top of the page without the need of
refreshing.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

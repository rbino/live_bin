# LiveBin

LiveBin is a simple tool used to inspect HTTP requests.

It tries not to get in your way, it doesn't parse the body or do other
fancy stuff with your request. This way you see exactly what was sent.
The idea is basically having the same output you would get by doing HTTP
requests to a listening instance of `netcat`.

Under the hood it uses the super cool
[Phoenix Live View](https://github.com/phoenixframework/phoenix_live_view),
so new requests are prepended at the top of the page without the need of
refreshing.

You can visit [liveb.in](https://liveb.in) to try it live.

## Running your instance

You can run your instance using the Docker image

```
export SECRET_KEY_BASE=$(mix phx.gen.secret)
# or `openssl rand -base64 48` if you don't have phx generators installed
docker run -e SECRET_KEY_BASE -p 4000:4000 rbino/live_bin:0.2.0
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Additional environment variables
live_bin accepts these additional environment variables, that you can pass with `-e`
to `docker run`:

- `PORT`: the listening port, that will have to be exposed from the container.
Defaults to `4000`.
- `PHX_HOST`: base host (e.g. `example.com`) where live_bin is served. Needed to
make websockets work and to correctly generate links. Defaults to `example.com`.
- `LIVE_BIN_INACTIVITY_TIMEOUT`: the timeout after which a bin will be deleted
if there's no activity on it, in milliseconds. Defaults to infinity.
- `LIVE_BIN_MAX_REQUESTS`: the max number of requests that a bin can receive
before being deleted. Defaults to `nil`, which means unlimited.
- `LIVE_BIN_USE_BIN_SUBDOMAINS`: if `true`, generates request URLs appear as
`<bin_id>.<host>` instead of `<host>/r/<bin_id>`. This just changes the way URLs
are generated, to make it work, the reverse proxy must perform the appropriate
URL rewriting (taking `<bin_id>` from the subdomain and putting it in the path).

### nginx configuration example
In `priv/examples/nginx-example.conf` you can find a sample `nginx` conf to
serve as reverse proxy for live_bin, with bin subdomains support. You should just be
able to replace `live_b.in` with your URL and, after obtaining SSL certificates,
you should be good to go.

## License
Copyright (c) 2019-2022 Riccardo Binetti <rbino@gmx.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

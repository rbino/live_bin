FROM bitwalker/alpine-elixir-phoenix:1.9.1 as builder

WORKDIR /app

ENV MIX_ENV=prod

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
  npm install

ADD . .

# Run frontend build, compile, and digest assets
RUN cd assets/ && \
  npm run deploy && \
  cd - && \
  mix do compile, phx.digest, release

# Keep this in sync with the one used to build alpine-elixir-phoenix
FROM alpine:3.10.2

# Set exposed ports
EXPOSE 4000

# Set the locale
ENV LANG C.UTF-8

# Install ncurses
RUN apk update && apk add ncurses && rm -rf /var/cache/apk/*

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/mfpb .

CMD ["./bin/mfpb", "start"]

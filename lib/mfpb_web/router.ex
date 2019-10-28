defmodule MFPBWeb.Router do
  use MFPBWeb, :router

  pipeline :browser do
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Phoenix.json_library()

    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug MFPBWeb.BodyReader
  end

  scope "/", MFPBWeb do
    pipe_through :browser

    live "/", IndexLive
    live "/b/:bin_id", BinLive
    get "/b/:bin_id/requests/:request_id/body", BinController, :get_body
  end

  scope "/r", MFPBWeb do
    pipe_through :api

    match :*, "/:bin_id/*path_tokens", RequestController, :request
  end
end

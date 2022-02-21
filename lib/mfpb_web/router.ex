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
    plug :put_root_layout, {MFPBWeb.LayoutView, :root}
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

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MFPBWeb.Telemetry
    end
  end
end

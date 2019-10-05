defmodule MFPBWeb.PageController do
  use MFPBWeb, :controller

  def index(conn, _params) do
    live_render(conn, MFPBWeb.BinLive)
  end
end

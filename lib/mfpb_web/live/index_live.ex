defmodule MFPBWeb.IndexLive do
  use Phoenix.LiveView

  alias MFPBWeb.IndexView

  def mount(_session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    IndexView.render("index.html", assigns)
  end
end

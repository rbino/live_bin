defmodule MFPBWeb.BinLive do
  use Phoenix.LiveView

  alias MFPB.Requests
  alias MFPB.Requests.Request
  alias MFPBWeb.BinView

  def mount(_session, socket) do
    :ok = Requests.subscribe()
    requests = Requests.get_all_requests()
    {:ok, assign(socket, requests: requests), temporary_assigns: [:requests]}
  end

  def render(assigns) do
    BinView.render("bin.html", assigns)
  end

  def handle_info(%Request{} = req, socket) do
    {:noreply, assign(socket, requests: [req])}
  end
end

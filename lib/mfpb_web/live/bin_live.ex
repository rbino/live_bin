defmodule MFPBWeb.BinLive do
  use Phoenix.LiveView

  alias MFPB.Requests
  alias MFPB.Requests.Request
  alias MFPBWeb.BinView
  alias MFPBWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    {:ok, socket, temporary_assigns: [:requests]}
  end

  def handle_params(%{"bin_id" => bin_id}, _uri, socket) do
    if Requests.bin_exists?(bin_id) do
      request_url = Routes.request_url(MFPBWeb.Endpoint, :request, bin_id, [])
      :ok = Requests.subscribe(bin_id)
      requests = Requests.get_all_requests(bin_id)

      {:noreply, assign(socket, requests: requests, request_url: request_url)}
    else
      Process.send_after(self(), :redirect_to_index, 5000)
      {:noreply, assign(socket, not_found: true)}
    end
  end

  def render(%{not_found: true} = assigns) do
    BinView.render("not_found.html", assigns)
  end

  def render(assigns) do
    BinView.render("bin.html", assigns)
  end

  def handle_info(%Request{} = req, socket) do
    {:noreply, assign(socket, requests: [req])}
  end

  def handle_info(:redirect_to_index, socket) do
    {:noreply, live_redirect(socket, to: "/")}
  end
end

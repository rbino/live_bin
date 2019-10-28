defmodule MFPBWeb.BinLive do
  use Phoenix.LiveView

  alias MFPB.Config
  alias MFPB.Requests
  alias MFPB.Requests.Request
  alias MFPBWeb.BinView
  alias MFPBWeb.Endpoint
  alias MFPBWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    {:ok, socket, temporary_assigns: [:requests]}
  end

  def handle_params(%{"bin_id" => bin_id}, _uri, socket) do
    if Requests.bin_exists?(bin_id) do
      :ok = Requests.subscribe(bin_id)
      requests = Requests.get_all_requests(bin_id)

      {:noreply,
       assign(socket, requests: requests, request_url: build_request_url(bin_id), bin_id: bin_id)}
    else
      Process.send_after(self(), :redirect_to_index, 5000)
      {:noreply, assign(socket, not_found: true)}
    end
  end

  defp build_request_url(bin_id) do
    if Config.bin_subdomains?() do
      url_config = Endpoint.config(:url, [])
      base_host = Keyword.fetch!(url_config, :host)
      scheme = Keyword.get(url_config, :scheme, "http")

      %URI{
        scheme: scheme,
        host: bin_id <> "." <> base_host
      }
      |> URI.to_string()
    else
      Routes.request_url(Endpoint, :request, bin_id, [])
    end
  end

  def render(%{not_found: true} = assigns) do
    BinView.render("not_found.html", assigns)
  end

  def render(%{timeout: true} = assigns) do
    BinView.render("timeout.html", assigns)
  end

  def render(%{size_exceeded: true} = assigns) do
    BinView.render("size_exceeded.html", assigns)
  end

  def render(assigns) do
    BinView.render("bin.html", assigns)
  end

  def handle_info({:request, %Request{} = req}, socket) do
    {:noreply, assign(socket, requests: [req])}
  end

  def handle_info(:bin_timeout, socket) do
    Process.send_after(self(), :redirect_to_index, 5000)
    {:noreply, assign(socket, timeout: true)}
  end

  def handle_info(:bin_size_exceeded, socket) do
    Process.send_after(self(), :redirect_to_index, 5000)
    {:noreply, assign(socket, size_exceeded: true)}
  end

  def handle_info(:redirect_to_index, socket) do
    {:noreply, live_redirect(socket, to: "/")}
  end
end

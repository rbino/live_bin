defmodule MFPBWeb.BinLive do
  use MFPBWeb, :live_view

  alias MFPB.Config
  alias MFPB.Requests
  alias MFPB.Requests.Request
  alias MFPBWeb.BinLive.RequestComponent
  alias MFPBWeb.Endpoint
  alias MFPBWeb.Router.Helpers, as: Routes

  def render(%{bin_error: _bin_error} = assigns) do
    bin_error(assigns)
  end

  def render(assigns) do
    ~H"""
    <%= if @request_url do %>
      <h2 class="mgt">Bin base URL</h2>
      <pre><code><%= @request_url %></code></pre>
      <p>
        Send your requests to this URL or any of its subpaths.
      </p>
      <hr>
      <h2>Requests</h2>
    <% end %>
    <div id="requests-container" phx-update="prepend">
      <%= for r <- @requests do %>
        <RequestComponent.request id={r.id} bin_id={@bin_id} request={r} />
      <% end %>
    </div>
    """
  end

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
      {:noreply, assign(socket, bin_error: "Bin not found")}
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

  def handle_info({:request, %Request{} = req}, socket) do
    {:noreply, assign(socket, requests: [req])}
  end

  def handle_info(:bin_timeout, socket) do
    Process.send_after(self(), :redirect_to_index, 5000)
    {:noreply, assign(socket, bin_error: "Bin inactivity timeout")}
  end

  def handle_info(:bin_size_exceeded, socket) do
    Process.send_after(self(), :redirect_to_index, 5000)
    {:noreply, assign(socket, bin_error: "Max bin size exceeded")}
  end

  def handle_info(:redirect_to_index, socket) do
    {:noreply, push_redirect(socket, to: "/")}
  end
end

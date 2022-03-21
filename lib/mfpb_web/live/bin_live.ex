defmodule MFPBWeb.BinLive do
  use MFPBWeb, :live_view

  alias MFPB.Config
  alias MFPB.Requests
  alias MFPB.Requests.Request
  alias MFPBWeb.BinLive.RequestComponent
  alias MFPBWeb.Endpoint
  alias MFPBWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <div class="px-4 mx-auto max-w-3xl">
      <div class="mt-8 mb-4 text-center">
        <div class="flex justify-center items-center gap-2">
          <clipboard-copy for="request-url" class="cursor-pointer" phx-click="url-copied">
            <.icon name={:clipboard_copy} outlined={true} class="w-7 h-7 mb-1" />
          </clipboard-copy>
          <code id="request-url" class="bg-slate-200 rounded-lg py-1 px-2 md:px-3 whitespace-nowrap text-xs md:text-lg"><%= @request_url %></code>
        </div>
        <p class="mt-4 mb-8 text-xs md:text-base">
          Send your requests to this URL or any of its subpaths
        </p>
      </div>
      <div id="requests-container" class="flex flex-col gap-4 pb-16" phx-update="prepend">
        <%= for r <- @requests do %>
          <RequestComponent.request id={r.id} bin_id={@bin_id} request={r} />
        <% end %>
      </div>
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
      {:noreply, bin_error(socket, "Bin not found")}
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
    {:noreply, bin_error(socket, "Bin inactivity timeout")}
  end

  def handle_info(:bin_size_exceeded, socket) do
    Process.send_after(self(), :redirect_to_index, 5000)
    {:noreply, bin_error(socket, "Max bin size exceeded")}
  end

  def handle_event("url-copied", _params, socket) do
    {:noreply, put_flash(socket, :info, "Bin URL copied to the clipboard")}
  end

  defp bin_error(socket, message) do
    socket
    |> put_flash(:error, message)
    |> push_redirect(to: "/")
  end
end

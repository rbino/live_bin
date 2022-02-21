defmodule MFPBWeb.IndexLive do
  use MFPBWeb, :live_view

  alias MFPB.Requests

  @impl true
  def render(assigns) do
    ~H"""
    <div class="row">
      <div class="column column-center text-center">
        <h1>mfpb</h1>
        <button class="button mg" phx-click="create" phx-throttle="1000">Create new bin</button>
      </div>
    </div>
    <div class="row">
      <div class="column">
        <h2>About</h2>
        <p>
          <b>mfpb</b> is a simple tool used to inspect HTTP requests.
        </p>
        <p>
          It tries not to get in your way, it doesn't parse the body or do other
          fancy stuff with your request. This way you see exactly what was sent.
          The idea is basically having the same output you would get by doing HTTP
          requests to a listening instance of <code>netcat</code>.
        </p>
        <p>
          Under the hood it uses the super cool
          <a target="_blank" href="https://github.com/phoenixframework/phoenix_live_view">Phoenix Live View</a>,
          so new requests are prepended at the top of the page without the need of
          refreshing.
        </p>
        <p>
          You can find the source <a target="_blank" href="https://github.com/rbino/mfpb">on Github</a>.
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("create", _params, socket) do
    case Requests.create_new_bin() do
      {:ok, bin_id} ->
        {:noreply, push_redirect(socket, to: "/b/#{bin_id}")}

      :error ->
        # TODO: handle this
        {:noreply, socket}
    end
  end
end

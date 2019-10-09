defmodule MFPBWeb.IndexLive do
  use Phoenix.LiveView

  alias MFPB.Requests
  alias MFPBWeb.IndexView

  def mount(_session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    IndexView.render("index.html", assigns)
  end

  def handle_event("create", _params, socket) do
    case Requests.create_new_bin() do
      {:ok, bin_id} ->
        {:noreply, live_redirect(socket, to: "/b/#{bin_id}")}

      :error ->
        # TODO: handle this
        {:noreply, socket}
    end
  end
end

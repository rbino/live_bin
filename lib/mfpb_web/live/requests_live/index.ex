defmodule MFPBWeb.RequestsLive.Index do
  use MFPBWeb, :live_view

  alias MFPB.Requests

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

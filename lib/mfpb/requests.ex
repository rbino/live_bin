defmodule MFPB.Requests do
  alias MFPB.Requests.Bin
  alias MFPB.Requests.Request

  def add_request(bin_id, %Request{} = request) when is_binary(bin_id) do
    with :ok <- Bin.append(bin_id, request),
         :ok <- Phoenix.PubSub.broadcast(MFPB.PubSub, "requests:#{bin_id}", request) do
      :ok
    end
  end

  def get_all_requests(bin_id) when is_binary(bin_id) do
    Bin.get_all(bin_id)
  end

  def subscribe(bin_id) when is_binary(bin_id) do
    Phoenix.PubSub.subscribe(MFPB.PubSub, "requests:#{bin_id}")
  end
end

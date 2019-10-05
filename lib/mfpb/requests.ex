defmodule MFPB.Requests do
  alias MFPB.Requests.Bin
  alias MFPB.Requests.Request

  def add_request(%Request{} = request) do
    with :ok <- Bin.append(Bin, request),
         :ok <- Phoenix.PubSub.broadcast(MFPB.PubSub, "requests", request) do
      :ok
    end
  end

  def get_all_requests do
    Bin.get_all(Bin)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(MFPB.PubSub, "requests")
  end
end

defmodule LiveBin.Requests do
  require Logger

  alias LiveBin.Requests.Bin
  alias LiveBin.Requests.Request
  alias LiveBin.Requests.Bin.Registry, as: BinRegistry
  alias LiveBin.Requests.Bin.Supervisor, as: BinSupervisor

  def create_new_bin do
    bin_id =
      :crypto.strong_rand_bytes(10)
      |> Base.encode32(case: :lower, padding: false)

    with {:ok, _pid} <- DynamicSupervisor.start_child(BinSupervisor, {Bin, bin_id: bin_id}) do
      {:ok, bin_id}
    else
      err ->
        Logger.warn("Error while creating new bin: #{inspect(err)}")
        :error
    end
  end

  def add_request(bin_id, %Request{} = request) when is_binary(bin_id) do
    with :ok <- Bin.append(bin_id, request),
         :ok <- Phoenix.PubSub.broadcast(LiveBin.PubSub, "bins:#{bin_id}", {:request, request}) do
      :ok
    end
  end

  def get_all_requests(bin_id) when is_binary(bin_id) do
    Bin.get_all(bin_id)
  end

  def fetch_request(bin_id, request_id) when is_binary(bin_id) and is_binary(request_id) do
    Bin.fetch(bin_id, request_id)
  end

  def subscribe(bin_id) when is_binary(bin_id) do
    Phoenix.PubSub.subscribe(LiveBin.PubSub, "bins:#{bin_id}")
  end

  def bin_exists?(bin_id) do
    case Registry.lookup(BinRegistry, bin_id) do
      [] -> false
      [{_pid, _value}] -> true
    end
  end
end

defmodule MFPB.Requests.Bin do
  use Agent

  alias MFPB.Requests.Request
  alias MFPB.Requests.Bin.Registry, as: BinRegistry

  def start_link(args) do
    {bin_id, _args} = Keyword.pop(args, :bin_id)
    Agent.start_link(fn -> [] end, name: via_tuple(bin_id))
  end

  def get_all(bin_id) do
    via_tuple(bin_id)
    |> Agent.get(fn state -> state end)
  end

  def append(bin_id, %Request{} = request) do
    via_tuple(bin_id)
    |> Agent.update(fn state -> [request | state] end)
  end

  defp via_tuple(bin_id) do
    {:via, Registry, {BinRegistry, bin_id}}
  end
end

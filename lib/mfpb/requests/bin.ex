defmodule MFPB.Requests.Bin do
  use Agent

  alias MFPB.Requests.Request

  def start_link(args) do
    name = Keyword.get(args, :name)
    Agent.start_link(fn -> [] end, name: name)
  end

  def get_all(bin) do
    Agent.get(bin, fn state -> state end)
  end

  def append(bin, %Request{} = request) do
    Agent.update(bin, fn state -> [request | state] end)
  end
end

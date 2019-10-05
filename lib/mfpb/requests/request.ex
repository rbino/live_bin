defmodule MFPB.Requests.Request do
  defstruct [
    :id,
    :timestamp,
    :method,
    :path,
    :query_string,
    :http_version,
    :body,
    headers: []
  ]

  alias MFPB.Requests.Request

  def new(opts \\ []) do
    id = UUID.uuid4()
    timestamp = DateTime.utc_now()
    opts = Keyword.merge([id: id, timestamp: timestamp], opts)
    struct(Request, opts)
  end
end

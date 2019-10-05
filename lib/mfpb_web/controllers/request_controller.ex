defmodule MFPBWeb.RequestController do
  use MFPBWeb, :controller

  alias MFPB.Requests
  alias MFPB.Requests.Request

  def request(conn, %{"path_tokens" => path_tokens}) do
    http_version = get_http_protocol(conn)
    body = conn.assigns[:body]

    %{
      method: method,
      query_string: query_string,
      req_headers: headers
    } = conn

    path = "/#{Enum.join(path_tokens, "/")}"

    req =
      Request.new(
        http_version: http_version,
        path: path,
        method: method,
        query_string: query_string,
        headers: headers,
        body: body
      )

    with :ok <- Requests.add_request(req) do
      send_resp(conn, :ok, req.id)
    end
  end
end

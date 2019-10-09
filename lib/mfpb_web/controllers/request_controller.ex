defmodule MFPBWeb.RequestController do
  use MFPBWeb, :controller

  alias MFPB.Requests
  alias MFPB.Requests.Request

  def request(conn, %{"bin_id" => bin_id, "path_tokens" => path_tokens}) do
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

    with true <- Requests.bin_exists?(bin_id),
         :ok <- Requests.add_request(bin_id, req) do
      send_resp(conn, :ok, req.id)
    else
      # Bin does not exist
      false ->
        send_resp(conn, :not_found, "")

      {:error, :bin_size_exceeded} ->
        send_resp(conn, :too_many_requests, "")
    end
  end
end

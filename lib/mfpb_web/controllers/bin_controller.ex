defmodule MFPBWeb.BinController do
  use MFPBWeb, :controller

  alias MFPB.Requests

  def get_body(conn, %{"bin_id" => bin_id, "request_id" => request_id}) do
    with {:exists, true} <- {:exists, Requests.bin_exists?(bin_id)},
         {:fetch, {:ok, request}} <- {:fetch, Requests.fetch_request(bin_id, request_id)} do
      {_, content_type} =
        Enum.find(request.headers, {"content-type", "application/octet-stream"}, fn
          {key, _value} ->
            key == "content-type"
        end)

      conn
      |> put_resp_content_type(content_type)
      |> send_resp(200, request.body)
    else
      {:exists, _} ->
        send_resp(conn, :not_found, "Bin not found")

      {:fetch, _} ->
        send_resp(conn, :not_found, "Request not found")
    end
  end
end

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

      download_opts = [
        content_type: content_type,
        filename: "body-" <> request.id
      ]

      conn
      |> send_download({:binary, request.body}, download_opts)
    else
      {:exists, _} ->
        send_resp(conn, :not_found, "Bin not found")

      {:fetch, _} ->
        send_resp(conn, :not_found, "Request not found")
    end
  end
end

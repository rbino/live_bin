defmodule MFPBWeb.BinView do
  use MFPBWeb, :view

  alias MFPB.Requests.Request

  def render_request(%Request{} = request) do
    start_line = start_line(request)
    headers = headers(request)

    start_line_and_headers = [start_line, "\n", headers]

    if request.body do
      [start_line_and_headers | ["\n\n", request.body]]
    else
      start_line_and_headers
    end
  end

  defp start_line(%Request{} = request) do
    %Request{
      method: method,
      path: path,
      query_string: query_string,
      http_version: http_version
    } = request

    if query_string == "" do
      "#{method} #{path} #{Atom.to_string(http_version)}"
    else
      "#{method} #{path}?#{query_string} #{Atom.to_string(http_version)}"
    end
  end

  defp headers(%Request{} = request) do
    for {key, value} <- request.headers do
      "#{Recase.to_header(key)}: #{value}"
    end
    |> Enum.join("\n")
  end
end

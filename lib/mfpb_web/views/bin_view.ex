defmodule MFPBWeb.BinView do
  use MFPBWeb, :view

  alias MFPB.Requests.Request
  alias MFPBWeb.Endpoint
  alias MFPBWeb.Router.Helpers, as: Routes

  def render_request(%Request{} = request) do
    start_line = start_line(request)
    headers = headers(request)

    start_line_and_headers = [start_line, "\n", headers]

    cond do
      has_printable_body?(request) ->
        [start_line_and_headers | ["\n\n", request.body]]

      true ->
        start_line_and_headers
    end
  end

  def has_printable_body?(%Request{body: nil}), do: false

  def has_printable_body?(%Request{body: body}) when is_binary(body) do
    String.valid?(body)
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

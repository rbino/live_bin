defmodule MFPBWeb.BinLive.RequestComponent do
  use MFPBWeb, :component

  alias MFPB.Requests.Request
  alias MFPBWeb.Endpoint

  def request(assigns) do
    ~H"""
    <div id={@id}>
      <h4>ID: <a href={"##{@id}"}><%= @id %></a></h4>
      <h5>Received at: <%= DateTime.to_iso8601(@request.timestamp) %></h5>
      <%= if @request.body && not printable?(@request) do %>
        <i>The body was hidden since it contains unprintable characters</i>
      <% end %>
      <.body request={@request} />
      <.body_link request={@request} bin_id={@bin_id} id={@id} />
      <hr/>
    </div>
    """
  end

  def body(assigns) do
    ~H'<pre><code><%= body_string(@request) %></code></pre>'
  end

  def body_link(assigns) do
    ~H"""
    <%= if @request.body do %>
      <a href={Routes.bin_path(Endpoint, :get_body, @bin_id, @id)}>Download body</a>
    <% end %>
    """
  end

  defp body_string(%Request{} = request) do
    start_line = start_line(request)
    headers = headers(request)

    start_line_and_headers = [start_line, "\n", headers]

    cond do
      printable?(request) ->
        IO.inspect(request.body)
        [start_line_and_headers | ["\n\n", request.body]]

      true ->
        start_line_and_headers
    end
  end

  defp printable?(%Request{body: nil}), do: false

  defp printable?(%Request{body: body}) when is_binary(body) do
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

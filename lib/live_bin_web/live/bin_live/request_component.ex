defmodule LiveBinWeb.BinLive.RequestComponent do
  use LiveBinWeb, :component

  alias LiveBin.Requests.Request
  alias LiveBinWeb.Endpoint

  def request(assigns) do
    ~H"""
    <div class="shadow-md hover:shadow-lg transition-shadow rounded-lg overflow-hidden" id={@id}>
      <div class="bg-slate-700 p-1">
        <h4 class="md:text-lg text-center text-slate-50">
          <a class="no-underline hover:underline hover:text-slate-50" href={"##{@id}"}><%= @id %></a>
        </h4>
      </div>
      <div class="flex flex-col gap-4 p-4 bg-slate-50">
        <%= if @request.body && not printable?(@request) do %>
          <i>The body was hidden since it contains unprintable characters</i>
        <% end %>
        <.body request={@request} />
        <.body_link request={@request} bin_id={@bin_id} id={@id} />
        <h5 class="text-slate-700">Received at: <%= DateTime.to_iso8601(@request.timestamp) %></h5>
      </div>
    </div>
    """
  end

  def body(assigns) do
    ~H"""
    <pre class="pre-wrap overflow-y-auto px-4 py-2 bg-slate-200 border-l-2 border-slate-700">
    <code><%= body_string(@request) %></code>
    </pre>
    """
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

defmodule LiveBinWeb.BodyReader do
  import Plug.Conn

  defmodule RequestTooLargeError do
    @moduledoc """
    Error raised when the request is too large.
    """

    defexception message:
                   "the request is too large. If you are willing to process " <>
                     "larger requests, please give a :length to Plug.Parsers",
                 plug_status: 413
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case read_body(conn) do
      {:ok, "", conn} ->
        conn

      {:ok, body, conn} ->
        assign(conn, :body, body)

      {:more, _partial, _conn} ->
        # TODO: handle large requests
        raise RequestTooLargeError

      {:error, :timeout} ->
        raise Plug.TimeoutError

      {:error, _reason} ->
        raise Plug.BadRequestError
    end
  end
end

defmodule EchoRequestWeb.PageController do
  use EchoRequestWeb, :controller

  def request(conn, %{"token" => token}) do
    request =
      case String.trim(conn.query_string) do
        "" -> "#{conn.method} #{conn.request_path}"
        _ -> "#{conn.method} #{conn.request_path}?#{conn.query_string}"
      end

    {:ok, body, conn} = Plug.Conn.read_body(conn, length: 8_000_000)

    handle(conn, token, request, body)
  end

  def handle(conn, token, request, body) do
    Registry.dispatch(:token_registry, token, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:request, request, body, conn.req_headers})
    end)

    send_resp(conn, 204, "")
  end
end

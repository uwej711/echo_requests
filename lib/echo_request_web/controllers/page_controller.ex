defmodule EchoRequestWeb.PageController do
  use EchoRequestWeb, :controller

  def request(conn, %{"token" => token}) do
    request =
      case String.strip(conn.query_string) do
        "" -> "#{conn.method} #{conn.request_path}"
        _ -> "#{conn.method} #{conn.request_path}?#{conn.query_string}"
      end

    Registry.dispatch(:token_registry, token, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:request, request, conn.req_headers})
    end)

    send_resp(conn, 204, "")
  end
end

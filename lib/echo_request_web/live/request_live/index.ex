defmodule EchoRequestWeb.RequestLive.Index do
  use EchoRequestWeb, :live_view

  @impl true
  def mount(_params, _session, %{connected: true} = socket) do
    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    token = UUID.uuid4()

    {:ok, _} = Registry.register(:token_registry, token, [])

    {:ok,
     socket
     |> assign(:foo, "bar")
     |> assign(:token, token)
     |> assign(:request_count, 0)
     |> stream(:requests, [])}
  end

  @impl true
  def handle_info({:request, request_message, headers}, socket) do
    request = %{id: socket.assigns.request_count, message: request_message, headers: inspect(headers), time: NaiveDateTime.local_now()}
    socket = update(socket, :request_count, fn c -> c + 1 end)
    {:noreply, stream_insert(socket, :requests, request, at: 0)}
  end
end

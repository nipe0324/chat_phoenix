defmodule ChatPhoenix.RoomChannel do
  use Phoenix.Channel
  alias ChatPhoenix.Repo
  alias ChatPhoenix.User

  # "rooms:lobby"トピックのjoin関数
  def join("rooms:lobby", message, socket) do
    user = Repo.get(User, socket.assigns[:user_id])
    if user do
      {:ok, %{email: user.email}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # イベント名"new:message"のIncoming eventsを処理する
  def handle_in("new:message", message, socket) do
    # broadcat!は同じチャネルのすべてのサブスクライバーにメッセージを送る
    broadcast! socket, "new:message", %{user: message["user"], body: message["body"]}
    {:noreply, socket}
  end
end

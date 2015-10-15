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
    # メッセージを作成
    user = Repo.get(User, socket.assigns[:user_id]) |> Repo.preload(:messages)
    message = Ecto.Model.build(user, :messages, content: message["body"])
    Repo.insert!(message)

    # broadcat!は同じチャネルのすべてのサブスクライバーにメッセージを送る
    broadcast! socket, "new:message", %{user: user.email, body: message.content}
    {:noreply, socket}
  end
end

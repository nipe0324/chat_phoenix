defmodule ChatPhoenix.MessageController do
  use ChatPhoenix.Web, :controller
  alias ChatPhoenix.Repo
  alias ChatPhoenix.Message

  @doc """
  メッセージ一覧取得API
  """
  def index(conn, _params) do
    # すべてのメッセージを取得。userも一緒にロードしておく
    messages = Repo.all(Message) |> Repo.preload(:user)
    render conn, :index, messages: messages
  end
end

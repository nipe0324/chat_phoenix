defmodule ChatPhoenix.HelloController do
  use ChatPhoenix.Web, :controller

  # indexアクション
  #  conn - リクエスト情報を全般を格納
  #  params - クエリストリングやフォーム入力などのパラメータを格納
  def index(conn, _params) do
    # index.html.eexテンプレートを表示する
    render conn, "index.html"
  end
end

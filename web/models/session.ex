defmodule ChatPhoenix.Session do
  alias ChatPhoenix.User

  @doc """
  ログイン処理をする

  get_by関数でUserモデルをemailで取得します
  authenticateが成功すれば、{:ok, user}を返し、失敗すれば:errorを返します
  """
  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  @doc """
  認証処理をする

  Comeonin.Bcrypt.checkpw関数でpasswordをハッシュ化してデータベースのハッシュ値と比較します
  """
  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  @doc """
  現在のログインユーザを取得するヘルパー関数

  get_session関数で:current_userからidを取得し、idが存在する場合はDBからUser情報を取得します
  """
  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: ChatPhoenix.Repo.get(User, id)
  end


  @doc """
  ログインしているかどうかを返すヘルパー関数
  """
  def logged_in?(conn) do
    !!current_user(conn)
  end
end

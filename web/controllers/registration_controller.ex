defmodule ChatPhoenix.RegistrationController do
  use ChatPhoenix.Web, :controller
  alias ChatPhoenix.User

  @doc """
  ユーザ登録画面の表示
  """
  def new(conn, _params) do
    # chnageset関数は、newメソッドのようなもので、Userのデータを返す
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  @doc """
  ユーザ登録処理
  """
  def create(conn, %{"user" => user_params}) do
    # フォーム情報user_paramsの値でuserデータを作成
    changeset = User.changeset(%User{}, user_params)

    # ユーザ登録
    case User.create(changeset, ChatPhoenix.Repo) do
      {:ok, user} ->
        # バリデーションに成功した場合、userレコードを作成し、ログインし、"/"にリダイレクト
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "ようこそ" <> changeset.params["email"])
        |> redirect(to: "/")
      {:error, changeset} ->
        # バリデーションに失敗した場合、"new.html"を表示
        conn
        |> put_flash(:info, "アカウントを作成できませんでした")
        |> render("new.html", changeset: changeset)
    end
  end
end

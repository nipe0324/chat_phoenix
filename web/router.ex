defmodule ChatPhoenix.Router do
  use ChatPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    # "GET /hello"にアクセスすると、HelloControllerのindexアクションが呼ばれる
    get "/hello", HelloController, :index

    # 登録画面表示(new)と登録処理(create)
    get  "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    # ログイン画面表示(:new)、ログイン処理(create)、ログアウト処理(delete)
    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatPhoenix do
  #   pipe_through :api
  # end

  defp put_user_token(conn, _) do
    if logged_in?(conn) do
      token = Phoenix.Token.sign(conn, "user", current_user(conn).id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end

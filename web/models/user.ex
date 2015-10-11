defmodule ChatPhoenix.User do
  use ChatPhoenix.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    # passwordフィールドを追加。virtual: trueとすることでデータベースには保存されない
    field :password, :string, virtual: true

    timestamps
  end

  # crypted_passwordの代わりにpasswordに変更
  # @required_fields ~w(email crypted_password)
  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  "model"と"params"に基づいたchangesetを作成する
  "params"がない場合は、invalidなchangesetを返します。

  castはparamsの値でモデルの値を設定
  update_changeは、"email"の値をフィールドの値を小文字に変更
  unique_constraintは、"email"にユニーク制約のバリデーション
  validate_formatは、"email"に"@"が含まれているかバリデーション
  validate_lengthは、"password"が5文字以上であるかバリデーション
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
  end

  @doc """
  userレコードを1件作成する
  成功時は {:ok, user} を返し、失敗時は {:error, changeset} を返す

  put_changeは、crypated_passwordに値を設定
  insert()は、テーブルにレコードを作成(SQLのinsert文が走る)
  ectoの関数であり、より詳細を知りたい場合は、http://www.phoenixframework.org/docs/ecto-models を参照してください
  """
  def create(changeset, repo) do
    changeset
    |> put_change(:crypted_password, hashed_password(changeset.params["password"]))
    |> repo.insert()
  end

  @doc """
  パスワードをハッシュ値にする
  Comeoninという値をハッシュ化するライブラリを使用しています
  defpはプライベートメソッド
  """
  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end

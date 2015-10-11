defmodule ChatPhoenix.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :crypted_password, :string, null: false

      timestamps
    end

    # emailフィールドにunique制約をつける
    create unique_index(:users, [:email])
  end
end

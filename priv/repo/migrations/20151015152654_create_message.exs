defmodule ChatPhoenix.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :user_id, references(:users)

      timestamps
    end
    create index(:messages, [:user_id])

  end
end

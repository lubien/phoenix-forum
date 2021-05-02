defmodule PhoenixForum.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :author, :string
      add :content, :text
      add :thread_id, references(:threads, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:thread_id])
  end
end

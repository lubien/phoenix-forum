defmodule PhoenixForum.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add :title, :string
      add :author, :string
      add :content, :text

      timestamps()
    end

  end
end

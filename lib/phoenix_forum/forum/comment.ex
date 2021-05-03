defmodule PhoenixForum.Forum.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixForum.Forum.Thread

  schema "comments" do
    field :author, :string
    field :content, :string
    belongs_to :thread, Thread

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:author, :content, :thread_id])
    |> validate_required([:author, :content, :thread_id])
    |> assoc_constraint(:thread)
  end
end

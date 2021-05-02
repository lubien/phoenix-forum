defmodule PhoenixForum.Repo.Migrations.FixCommentsForeignKey do
  use Ecto.Migration

  def up do
    execute """
      alter table comments
      drop constraint comments_thread_id_fkey,
      add constraint comments_thread_id_fkey
        foreign key (thread_id)
        references threads(id)
        on update cascade
        on delete cascade;
    """
  end

  def down do
    execute """
      alter table comments
      drop constraint comments_thread_id_fkey,
      add constraint comments_thread_id_fkey
        foreign key (thread_id)
        references threads(id)
        on update no action
        on delete no action;
    """
  end
end

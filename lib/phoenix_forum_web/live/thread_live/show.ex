defmodule PhoenixForumWeb.ThreadLive.Show do
  use PhoenixForumWeb, :live_view

  import Ecto.Query, only: [from: 2]
  alias PhoenixForum.Forum
  alias PhoenixForum.Forum.Comment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    thread = Forum.get_thread!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Show Thread")
     |> assign(:thread, thread)
     |> assign(:comments, list_comments_for_thread(thread.id))}
  end

  defp list_comments_for_thread(thread_id) do
    query = from c in Comment, where: c.thread_id > ^thread_id
    Forum.list_comments(query)
  end
end

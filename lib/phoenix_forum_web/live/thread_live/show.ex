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
  def handle_params(%{"id" => id} = params, _uri, socket) do
    thread = Forum.get_thread!(id)
    {:noreply,
      socket
      |> assign(:thread, thread)
      |> assign(:comments, list_comments_for_thread(id))
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :edit_comment, %{"comment_id" => comment_id}) do
    socket
    |> assign(:page_title, "Edit Comment")
    |> assign(:comment, Forum.get_comment!(comment_id))
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Show Thread")
    |> assign(:comment, %Comment{})
  end

  @impl true
  def handle_event("delete_comment", %{"id" => id}, socket) do
    comment = Forum.get_comment!(id)
    {:ok, _} = Forum.delete_comment(comment)

    {:noreply, assign(socket, :comments, list_comments_for_thread(socket.assigns.thread.id))}
  end

  defp list_comments_for_thread(thread_id) do
    query = from c in Comment, where: c.thread_id == ^thread_id
    Forum.list_comments(query)
  end
end

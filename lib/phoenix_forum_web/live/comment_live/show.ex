defmodule PhoenixForumWeb.CommentLive.Show do
  use PhoenixForumWeb, :live_view

  alias PhoenixForum.Forum

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:comment, Forum.get_comment!(id))}
  end

  defp page_title(:show), do: "Show Comment"
  defp page_title(:edit), do: "Edit Comment"
end

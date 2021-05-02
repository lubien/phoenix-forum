defmodule PhoenixForumWeb.ThreadLive.Index do
  use PhoenixForumWeb, :live_view

  alias PhoenixForum.Forum

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:page_title, "Listing Threads")
      |> assign(:threads, list_threads())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    thread = Forum.get_thread!(id)
    {:ok, _} = Forum.delete_thread(thread)

    {:noreply, assign(socket, :threads, list_threads())}
  end

  defp list_threads do
    Forum.list_threads()
  end
end

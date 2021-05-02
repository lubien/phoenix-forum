defmodule PhoenixForumWeb.ThreadLive.Index do
  use PhoenixForumWeb, :live_view

  alias PhoenixForum.Forum
  alias PhoenixForum.Forum.Thread

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :threads, list_threads())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Thread")
    |> assign(:thread, Forum.get_thread!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Thread")
    |> assign(:thread, %Thread{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Threads")
    |> assign(:thread, nil)
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

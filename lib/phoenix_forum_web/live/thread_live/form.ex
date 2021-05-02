defmodule PhoenixForumWeb.ThreadLive.Form do
  use PhoenixForumWeb, :live_view

  alias PhoenixForum.Forum
  alias PhoenixForum.Forum.Thread

  @impl true
  def mount(params, _session, socket) do
    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    thread = %Thread{}
    socket
    |> assign(:page_title, "New Thread")
    |> assign(:action, :new)
    |> assign(:thread, thread)
    |> assign(:changeset, Forum.change_thread(thread))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    thread = Forum.get_thread!(id)
    socket
    |> assign(:page_title, "Edit Thread")
    |> assign(:action, :edit)
    |> assign(:thread, thread)
    |> assign(:changeset, Forum.change_thread(thread))
  end

  @impl true
  def handle_event("validate", %{"thread" => thread_params}, socket) do
    changeset =
      socket.assigns.thread
      |> Forum.change_thread(thread_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"thread" => thread_params}, socket) do
    save_thread(socket, socket.assigns.action, thread_params)
  end

  defp save_thread(socket, :edit, thread_params) do
    case Forum.update_thread(socket.assigns.thread, thread_params) do
      {:ok, thread} ->
        {:noreply,
         socket
         |> put_flash(:info, "Thread updated successfully")
         |> push_redirect(to: Routes.thread_show_path(socket, :show, thread.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_thread(socket, :new, thread_params) do
    case Forum.create_thread(thread_params) do
      {:ok, thread} ->
        {:noreply,
         socket
         |> put_flash(:info, "Thread created successfully")
         |> push_redirect(to: Routes.thread_show_path(socket, :show, thread.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

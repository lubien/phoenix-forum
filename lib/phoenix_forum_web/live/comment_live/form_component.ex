defmodule PhoenixForumWeb.CommentLive.FormComponent do
  use PhoenixForumWeb, :live_component

  alias PhoenixForum.Forum

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Forum.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Forum.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_comment(socket, :edit, comment_params) do
    case Forum.update_comment(socket.assigns.comment, comment_params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_comment(socket, :new, comment_params) do
    case Forum.create_comment(comment_params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

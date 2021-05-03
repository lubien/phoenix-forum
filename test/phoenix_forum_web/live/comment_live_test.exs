defmodule PhoenixForumWeb.CommentLiveTest do
  use PhoenixForumWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixForum.Forum

  @create_thread_attrs %{
    author: "thread author",
    content: "thread content",
    title: "thread title"
  }
  @create_attrs %{author: "some author", content: "some content"}
  @update_attrs %{author: "some updated author", content: "some updated content"}
  @invalid_attrs %{author: nil, content: nil}

  defp fixture(:thread) do
    {:ok, thread} = Forum.create_thread(@create_thread_attrs)
    thread
  end

  defp fixture(:comment, thread) do
    attrs = @create_attrs |> Map.put(:thread_id, thread.id)
    {:ok, comment} = Forum.create_comment(attrs)
    comment
  end

  defp create_comment(_) do
    thread = fixture(:thread)
    comment = fixture(:comment, thread)
    %{comment: comment, thread: thread}
  end

  describe "Index" do
    setup [:create_comment]

    test "lists all comments of a thread", %{conn: conn, comment: comment, thread: thread} do
      {:ok, _index_live, html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Replies"
      assert html =~ comment.author
    end

    test "saves new comment", %{conn: conn, thread: thread} do
      {:ok, index_live, _html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      assert index_live
             |> form("#comment-form", comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#comment-form", comment: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Comment created successfully"
      assert html =~ "some author"
    end

    test "updates comment in listing", %{conn: conn, comment: comment, thread: thread} do
      {:ok, index_live, _html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      index_live |> element("#comment-#{comment.id} a", "Edit") |> render_click()

      assert_patch(index_live, Routes.thread_show_path(conn, :edit_comment, thread, comment))

      assert index_live
             |> form("#comment-form", comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#comment-form", comment: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Comment updated successfully"
      assert html =~ "some updated author"
    end

    test "deletes comment in listing", %{conn: conn, comment: comment, thread: thread} do
      {:ok, index_live, _html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      assert index_live |> element("#comment-#{comment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#comment-#{comment.id}")
    end
  end

  describe "Show" do
    setup [:create_comment]

    test "updates comment within modal", %{conn: conn, comment: comment, thread: thread} do
      {:ok, show_live, _html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      show_live |> element("#comment-#{comment.id} .edit-comment") |> render_click()

      assert_patch(show_live, Routes.thread_show_path(conn, :edit_comment, thread, comment))

      assert show_live
             |> form("#comment-form", comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#comment-form", comment: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Comment updated successfully"
      assert html =~ "some updated author"
    end
  end
end

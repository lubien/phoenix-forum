defmodule PhoenixForumWeb.ThreadLiveTest do
  use PhoenixForumWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixForum.Forum

  @create_attrs %{author: "some author", content: "some content", title: "some title"}
  @update_attrs %{
    author: "some updated author",
    content: "some updated content",
    title: "some updated title"
  }
  @invalid_attrs %{author: nil, content: nil, title: nil}

  defp fixture(:thread) do
    {:ok, thread} = Forum.create_thread(@create_attrs)
    thread
  end

  defp create_thread(_) do
    thread = fixture(:thread)
    %{thread: thread}
  end

  describe "Index" do
    setup [:create_thread]

    test "lists all threads", %{conn: conn, thread: thread} do
      {:ok, _index_live, html} = live(conn, Routes.thread_index_path(conn, :index))

      assert html =~ "Listing Threads"
      assert html =~ thread.title
    end

    test "saves new thread", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.thread_index_path(conn, :index))

      {:ok, form_live, _html} =
        index_live |> element("#new-thread") |> render_click() |> follow_redirect(conn)

      assert_redirected(index_live, Routes.thread_form_path(conn, :new))

      assert form_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        form_live
        |> form("#thread-form", thread: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn)

      assert html =~ "Thread created successfully"
      assert html =~ "some author"
    end

    test "updates thread in listing", %{conn: conn, thread: thread} do
      {:ok, index_live, _html} = live(conn, Routes.thread_index_path(conn, :index))

      {:ok, edit_live, _html} =
        index_live
        |> element("#thread-#{thread.id} a.edit-thread", "Edit")
        |> render_click()
        |> follow_redirect(conn)

      assert_redirected(index_live, Routes.thread_form_path(conn, :edit, thread))

      assert edit_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        edit_live
        |> form("#thread-form", thread: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Thread updated successfully"
      assert html =~ "some updated author"
    end

    test "deletes thread in listing", %{conn: conn, thread: thread} do
      {:ok, index_live, _html} = live(conn, Routes.thread_index_path(conn, :index))

      assert index_live |> element("#thread-#{thread.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#thread-#{thread.id}")
    end
  end

  describe "Show" do
    setup [:create_thread]

    test "displays thread", %{conn: conn, thread: thread} do
      {:ok, _show_live, html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Show Thread"
      assert html =~ thread.author
    end

    test "updates thread using form", %{conn: conn, thread: thread} do
      {:ok, show_live, _html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      {:ok, edit_live, _html} =
        show_live |> element("#thread-edit") |> render_click() |> follow_redirect(conn)

      assert_redirected(show_live, Routes.thread_form_path(conn, :edit, thread))

      assert edit_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        edit_live
        |> form("#thread-form", thread: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Thread updated successfully"
      assert html =~ "some updated author"
    end
  end
end

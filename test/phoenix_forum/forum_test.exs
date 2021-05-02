defmodule PhoenixForum.ForumTest do
  use PhoenixForum.DataCase

  alias PhoenixForum.Forum

  describe "threads" do
    alias PhoenixForum.Forum.Thread

    @valid_attrs %{author: "some author", content: "some content", title: "some title"}
    @update_attrs %{author: "some updated author", content: "some updated content", title: "some updated title"}
    @invalid_attrs %{author: nil, content: nil, title: nil}

    def thread_fixture(attrs \\ %{}) do
      {:ok, thread} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forum.create_thread()

      thread
    end

    test "list_threads/0 returns all threads" do
      thread = thread_fixture()
      assert Forum.list_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = thread_fixture()
      assert Forum.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      assert {:ok, %Thread{} = thread} = Forum.create_thread(@valid_attrs)
      assert thread.author == "some author"
      assert thread.content == "some content"
      assert thread.title == "some title"
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{} = thread} = Forum.update_thread(thread, @update_attrs)
      assert thread.author == "some updated author"
      assert thread.content == "some updated content"
      assert thread.title == "some updated title"
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = thread_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_thread(thread, @invalid_attrs)
      assert thread == Forum.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{}} = Forum.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = thread_fixture()
      assert %Ecto.Changeset{} = Forum.change_thread(thread)
    end
  end

  describe "comments" do
    alias PhoenixForum.Forum.Comment

    @valid_attrs %{author: "some author", content: "some content"}
    @update_attrs %{author: "some updated author", content: "some updated content"}
    @invalid_attrs %{author: nil, content: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forum.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Forum.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Forum.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Forum.create_comment(@valid_attrs)
      assert comment.author == "some author"
      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Forum.update_comment(comment, @update_attrs)
      assert comment.author == "some updated author"
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_comment(comment, @invalid_attrs)
      assert comment == Forum.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Forum.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Forum.change_comment(comment)
    end
  end
end

defmodule PhoenixForumWeb.Router do
  use PhoenixForumWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PhoenixForumWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixForumWeb do
    pipe_through :browser

    live "/", ThreadLive.Index, :index
    live "/threads/new", ThreadLive.Index, :new
    live "/threads/:id/edit", ThreadLive.Index, :edit

    live "/threads/:id", ThreadLive.Show, :show
    live "/threads/:id/show/edit", ThreadLive.Show, :edit

    live "/comments", CommentLive.Index, :index
    live "/comments/new", CommentLive.Index, :new
    live "/comments/:id/edit", CommentLive.Index, :edit

    live "/comments/:id", CommentLive.Show, :show
    live "/comments/:id/show/edit", CommentLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixForumWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PhoenixForumWeb.Telemetry
    end
  end
end

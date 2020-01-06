defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Bank.Auth.Pipeline
  end

  pipeline :ensure_authed_access do
    plug(Guardian.Plug.EnsureAuthenticated, %{"typ" => "access", handler: Bank.HttpErrorHandler})
  end

  scope "/", BankWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", BankWeb do
    pipe_through :api

    post "/users/create", UserController, :create
    post "/users/login", UserController, :login

    get "/transactions/report", TransactionController, :report
  end

  scope "/api", BankWeb do
    pipe_through [:api, :auth]
    
    post "/transactions/transfer", TransactionController, :transfer
    post "/transactions/cashout", TransactionController, :cashout
  end

end

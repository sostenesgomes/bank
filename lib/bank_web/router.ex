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
  end

  scope "/api", BankWeb do
    pipe_through [:api, :auth]
    
    post "/transactions/transfer", TransactionController, :transfer
    #resources "/transactions/transfers/show", PageController, :show_test

    #post "/cashout", TransferController, :cashout
    #get "/report", TransferController, :report
  end
end

defmodule ReWeb.Router do
  use ReWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(ReWeb.GuardianPipeline)
  end

  scope "/", ReWeb do
    pipe_through(:api)

    resources("/neighborhoods", NeighborhoodController, only: [:index])

    resources "/listings", ListingController, except: [:new] do
      resources("/images", ImageController, only: [:index, :create, :delete])
      resources("/interests", InterestController, only: [:create])
      resources("/related", RelatedController, only: [:index])

      put("/images_orders", ImageController, :order)
    end

    resources("/featured_listings", FeaturedController, only: [:index])
  end

  scope "/users", ReWeb do
    pipe_through(:api)

    post("/login", UserController, :login)
    post("/register", UserController, :register)
    post("/reset_password", UserController, :reset_password)
    post("/redefine_password", UserController, :redefine_password)
    post("/edit_password", UserController, :edit_password)

    put("/change_email", UserController, :change_email)
    put("/confirm", UserController, :confirm)
  end

  if Mix.env() == :dev do
    pipeline :browser do
      plug(:accepts, ["html"])
      plug(:fetch_session)
      plug(:fetch_flash)
      plug(:protect_from_forgery)
      plug(:put_secure_browser_headers)
    end

    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox")
    end
  end
end

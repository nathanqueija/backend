defmodule ReWeb.ImageController do
  use ReWeb, :controller
  use ReWeb.GuardedController

  alias Re.{
    Images,
    Listings
  }

  action_fallback ReWeb.FallbackController

  def index(conn, %{"listing_id" => listing_id}, user) do
    with :ok <- Bodyguard.permit(Images, :index_images, user, listing_id),
         {:ok, images} <- Images.all(listing_id),
      do: render(conn, "index.json", images: images)
  end

  def create(conn, %{"listing_id" => listing_id, "image" => image_params}, user) do
    with {:ok, listing} <- Listings.get(listing_id),
         :ok <- Bodyguard.permit(Images, :create_images, user, listing),
         {:ok, image} <- Images.insert(image_params, listing.id)
      do
        conn
        |> put_status(:created)
        |> render("create.json", image: image)
    end
  end

  def delete(conn, %{"listing_id" => listing_id, "id" => image_id}, user) do
    with {:ok, image} <- Images.get_per_listing(listing_id, image_id),
         :ok <- Bodyguard.permit(Images, :delete_images, user, listing_id),
         {:ok, _image} <- Images.delete(image),
      do: send_resp(conn, :no_content, "")
  end
end

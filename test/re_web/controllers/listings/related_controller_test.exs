defmodule ReWeb.RelatedControllerTest do
  use ReWeb.ConnCase

  alias ReWeb.Guardian

  import Re.Factory

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    admin_user = insert(:user, email: "admin@email.com", role: "admin")
    user_user = insert(:user, email: "user@email.com", role: "user")

    {:ok,
     unauthenticated_conn: conn,
     admin_conn: login_as(conn, admin_user),
     user_conn: login_as(conn, user_user)}
  end

  describe "index" do
    test "related listings for admin user", %{admin_conn: conn} do
      listing =
        insert(:listing, address: build(:address, neighborhood: "Ipanema"), price: 100_000)

      %{id: id2} =
        insert(:listing, address: build(:address, neighborhood: "Ipanema"), price: 100_000)

      conn = get(conn, listing_related_path(conn, :index, listing))

      response = json_response(conn, 200)
      assert [%{"id" => ^id2}] = response["listings"]
    end

    test "related listings for non user", %{admin_conn: conn} do
      listing =
        insert(:listing, address: build(:address, neighborhood: "Ipanema"), price: 100_000)

      %{id: id2} =
        insert(:listing, address: build(:address, neighborhood: "Ipanema"), price: 100_000)

      conn = get(conn, listing_related_path(conn, :index, listing))

      response = json_response(conn, 200)
      assert [%{"id" => ^id2}] = response["listings"]
    end

    test "related listings for unauthenticated request", %{conn: conn} do
      listing =
        insert(:listing, address: build(:address, neighborhood: "Ipanema"), price: 100_000)

      %{id: id2} =
        insert(:listing, address: build(:address, neighborhood: "Ipanema"), price: 100_000)

      conn = get(conn, listing_related_path(conn, :index, listing))

      response = json_response(conn, 200)
      assert [%{"id" => ^id2}] = response["listings"]
    end

    test "should return only 4 related listings", %{conn: conn} do
      address = insert(:address)
      listing = insert(:listing, address: address)
      insert_list(10, :listing, address: address)

      conn = get(conn, listing_related_path(conn, :index, listing, page_size: 4))

      response = json_response(conn, 200)
      assert length(response["listings"]) == 4
      assert response["total_entries"] == 10

      conn = get(conn, listing_related_path(conn, :index, listing), page_size: 4, page: 3)

      response = json_response(conn, 200)
      assert length(response["listings"]) == 2
      assert response["total_entries"] == 10
    end
  end
end

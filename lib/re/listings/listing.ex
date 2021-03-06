defmodule Re.Listing do
  @moduledoc """
  Model for listings, that is, each apartment or real estate piece on sale.
  """
  use Ecto.Schema

  import Ecto.Changeset

  schema "listings" do
    field(:type, :string)
    field(:complement, :string)
    field(:description, :string)
    field(:price, :integer)
    field(:floor, :string)
    field(:rooms, :integer)
    field(:bathrooms, :integer)
    field(:area, :integer)
    field(:garage_spots, :integer)
    field(:score, :integer)
    field(:matterport_code, :string)
    field(:is_active, :boolean)
    field(:is_exclusive, :boolean, default: false)

    belongs_to(:address, Re.Address)
    belongs_to(:user, Re.User)
    has_many(:images, Re.Image)

    timestamps()
  end

  @types ~w(Apartamento Casa Cobertura)

  @required ~w(type description price rooms bathrooms
               area garage_spots score address_id user_id)a
  @optional ~w(complement floor matterport_code is_active is_exclusive)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_number(:bathrooms, greater_than_or_equal_to: 0)
    |> validate_number(:garage_spots, greater_than_or_equal_to: 0)
    |> validate_number(:score, greater_than: 0, less_than: 5)
    |> validate_inclusion(:type, @types, message: "should be one of: [#{Enum.join(@types, " ")}]")
  end
end

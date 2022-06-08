defmodule Bebemayotte.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item" do
    field :id_item, :string
    field :Caption, :string
    field :CostPrice, :decimal
    field :FamilyId, :string
    field :SubFamilyId, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:id_item, :Caption, :FamilyId, :SubFamilyId, :CostPrice])
    |> validate_required([:id_item, :Caption, :FamilyId, :SubFamilyId, :CostPrice])
  end
end

defmodule Bebemayotte.Souscategories do
  use Ecto.Schema
  import Ecto.Changeset

  schema "souscategorie" do
    field :id_souscat, :string
    field :nom_souscat, :string
    field :id_cat, :string
    field :photolink, :string
  end

  def changeset(souscategories, attrs) do
    souscategories
      |> cast(attrs, [:id_souscat, :nom_souscat, :id_cat, :photolink])
      |> validate_required([:id_souscat, :nom_souscat, :id_cat, :photolink])
  end
end

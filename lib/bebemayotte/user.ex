defmodule Bebemayotte.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :adresseMessage, :string
    field :batiment, :string
    field :codepostal, :string
    field :id_user, :integer
    field :identifiant, :string
    field :motdepasse, :string
    field :nom, :string
    field :nom_affiche, :string
    field :nom_entreprise, :string
    field :nom_rue, :string
    field :pays, :string
    field :prenom, :string
    field :telephone, :string
    field :ville, :string
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id_user, :nom, :prenom, :nom_affiche, :nom_rue, :batiment, :pays,
    :ville, :identifiant, :adresseMessage, :codepostal, :telephone, :motdepasse, :nom_entreprise])
    |> validate_required([:id_user, :nom, :prenom, :nom_affiche, :nom_rue, :batiment,
    :pays, :ville, :identifiant, :adresseMessage, :codepostal, :telephone, :nom_entreprise])
    |> validate_required(:motdepasse)
    |> hash_password()
    |> unique_constraint(:id_user)
    |> unique_constraint(:telephone)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :motdepasse)
      |> to_string
    val_crypt = Pbkdf2.hash_pwd_salt(password)
    put_change(changeset, :motdepasse, val_crypt)
  end

  def changeset_uptade_password(user, attrs) do
    user
      |> cast(attrs, [:motdepasse])
  end

  def update_password_changeset(user, attrs) do
   user
      |> cast(attrs, [:motdepasse])
      |> hash_password()
  end

end

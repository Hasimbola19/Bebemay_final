defmodule Bebemayotte.Repo.Migrations.Ajout_Du_Champ_Modif_Produit do
  use Ecto.Migration

  def change do
    alter table(:produits) do
      add :modif, :boolean
    end
  end
end

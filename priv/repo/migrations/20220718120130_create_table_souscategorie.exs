defmodule Bebemayotte.Repo.Migrations.CreateTableSouscategorie do
  use Ecto.Migration

  def change do
    create table(:souscategorie) do
      add :id_souscat, :string
      add :nom_souscat, :string
      add :id_cat, :string
      add :photolink, :string
    end
  end
end

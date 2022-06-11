defmodule Bebemayotte.Repo.Migrations.AjoutChampImageversion do
  use Ecto.Migration

  def change do
    alter table(:produits) do
      add :imageVersion, :integer
    end
  end
end

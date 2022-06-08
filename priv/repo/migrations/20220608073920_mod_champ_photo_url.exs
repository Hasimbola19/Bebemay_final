defmodule Bebemayotte.Repo.Migrations.ModChampPhotoUrl do
  use Ecto.Migration

  def change do
    alter table(:produits) do
      modify :photolink, :string
    end
  end
end

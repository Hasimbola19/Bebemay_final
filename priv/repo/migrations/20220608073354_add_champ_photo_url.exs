defmodule Bebemayotte.Repo.Migrations.AddChampPhotoUrl do
  use Ecto.Migration

  def change do
    alter table(:produits) do
      add :photo_url, :string
    end
  end
end

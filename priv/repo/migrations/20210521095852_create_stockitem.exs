defmodule Bebemayotte.Repo.Migrations.CreateStockitem do
  use Ecto.Migration

  def change do
    create table(:stockitem) do
      add :real_Stock, :decimal
      add :item_id, :string

      timestamps()
    end

  end
end

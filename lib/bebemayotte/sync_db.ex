defmodule Bebemayotte.SyncDb do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.EBPRepo
  alias Bebemayotte.Categorie
  alias Bebemayotte.Produit
  alias Bebemayotte.Souscategorie
  alias Bebemayotte.Souscategories

  @topic inspect(__MODULE__)
  def subscribe do
    Phoenix.PubSub.subscribe(Bebemayotte.PubSub, @topic)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Bebemayotte.PubSub, @topic, {__MODULE__, event, result})
  end

  def start_link do
    Task.start_link(&sync/0)
  end

  defp condition_stock(x) do
    if Decimal.to_integer(x) > 0 do
      true
    else
      false
    end
  end

  defp stock_condition(x) do
    if x <= 0 do
      0
    else
      Decimal.to_integer(x)
    end
  end

  def del_pro do
    Repo.delete_all(Produit)
    File.rm_rf(Path.expand("assets/static/images/uploads"))
  end

  def create_pro do
    File.mkdir(Path.expand("assets/static/images/uploads"))
  end

  # COMPARE THE VALUES FROM POSTGRES AND SQL SERVER DATABASES

  # TABLE CATEGORIES

  defp updt_cat do
    query = Repo.all(from a in Categorie,
      select: a.id_cat)
      if query == [] do
        {:ok, queri} = EBPRepo.query("SELECT Id,Caption FROM ItemFamily")
        for c <- queri.rows do
          {:ok, cat_id} = Enum.fetch(c,0)
          {:ok, cat_nom} = Enum.fetch(c,1)
          params = %{
            "id_cat" => cat_id,
            "nom_cat" => cat_nom
          }
          %Categorie{}
            |> Categorie.changeset(params)
            |> Repo.insert()
        end
      else
        liste = Enum.join(query,"','")
       {:ok, queri}  = EBPRepo.query("SELECT Id,Caption FROM ItemFamily WHERE Id NOT IN ('#{liste}')")
        for c <- queri.rows do
          {:ok, cat_id} = Enum.fetch(c,0)
          {:ok, cat_nom} = Enum.fetch(c,1)
          params = %{
            "id_cat" => cat_id,
            "nom_cat" => cat_nom
          }
          %Categorie{}
            |> Categorie.changeset(params)
            |> Repo.insert()
        end
      end
  end

  defp del do
    Repo.delete_all(Produit)
    Repo.delete_all(Categorie)
    Repo.delete_all(Souscategorie)
    File.rm_rf(Path.expand("assets/static/images/uploads"))
    File.mkdir(Path.expand("assets/static/images/uploads"))
  end

  def insert_prod do
    if File.exists?(Path.expand("assets/static/images/uploads")) do
      :ok
    else
      {:ok, File.mkdir(Path.expand("assets/static/images/uploads"))}
    end
    query = Repo.all(from a in Produit,
    select: a.id_produit)
    liste = Enum.join(query, "','")
    {:ok, queri} = EBPRepo.query("SELECT Item.Id FROM Item WHERE Item.Id NOT IN ('#{liste}') AND Item.AllowPublishOnWeb = 1")
    # IO.inspect queri
    if queri.rows == [] do
      :ok
    else
      for d <- queri.rows do
        {:ok, id} = Enum.fetch(d, 0)
        {:ok, value} = EBPRepo.query("SELECT Item.FamilyId,Item.Id,Item.ItemImage,Item.SalePriceVatExcluded,Item.SubFamilyId,Item.Caption, Item.ImageVersion,Item.RealStock FROM Item WHERE Item.Id = '#{id}'")
        for c <- value.rows do
          {:ok, cat_id} = Enum.fetch(c, 0)
          {:ok, prod_id} = Enum.fetch(c, 1)
          {:ok, photo} = Enum.fetch(c, 2)
          {:ok, prix} = Enum.fetch(c, 3)
          {:ok, souscat_id} = Enum.fetch(c, 4)
          {:ok, capt} = Enum.fetch(c, 5)
          {:ok, afficher} = Enum.fetch(c, 6)
          {:ok, stock_max} = Enum.fetch(c, 7)
        if photo != nil do
          File.write(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"), photo, [:binary])
            params = %{
              "id_produit" => prod_id,
              "title" => capt,
              "photolink" => "/images/uploads/#{prod_id}.jpeg",
              "id_cat" => cat_id,
              "id_souscat" => souscat_id,
              "stockstatus" => condition_stock(stock_max),
              "stockmax" => stock_condition(stock_max),
              "price" => prix,
              "id_user" => 0,
              "imageVersion" => afficher
            }
            %Produit{}
              |> Produit.changeset(params)
              |> Repo.insert()
          else
            params = %{
              "id_produit" => prod_id,
              "title" => capt,
              "photolink" => "/images/empty.png",
              "id_cat" => cat_id,
              "id_souscat" => souscat_id,
              "stockstatus" => condition_stock(stock_max),
              "stockmax" => stock_condition(stock_max),
              "price" => prix,
              "id_user" => 0,
              "imageVersion" => afficher
            }
            %Produit{}
              |> Produit.changeset(params)
              |> Repo.insert()
          end
        end
      end
    end
  end

    # TABLE SOUSCATEGORIE
  defp updt_scat do
    queri = Repo.all(from a in Souscategorie,
    select: a.id_souscat)
    if queri == [] do
      {:ok, souscategorie} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption, ItemFamilyId FROM ItemSubFamily")
      for sc <- souscategorie.rows do
        {:ok, subfamilyid} = Enum.fetch(sc, 0)
        {:ok, nom} = Enum.fetch(sc, 1)
        {:ok, familyid} = Enum.fetch(sc, 2)
        params = %{
          "id_souscat" => subfamilyid,
          "nom_souscat" => nom,
          "id_cat" => familyid
        }
        %Souscategorie{}
          |> Souscategorie.changeset(params)
          |> Repo.insert()
      end
    else
      liste = Enum.join(queri, "','")
      {:ok, souscategorie} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption, ItemFamilyId FROM ItemSubFamily WHERE Id NOT IN ('#{liste}')")
      for sc <- souscategorie.rows do
        {:ok, subfamilyid} = Enum.fetch(sc, 0)
        {:ok, nom} = Enum.fetch(sc, 1)
        {:ok, familyid} = Enum.fetch(sc, 2)
        params = %{
          "id_souscat" => subfamilyid,
          "nom_souscat" => nom,
          "id_cat" => familyid
        }
        %Souscategorie{}
          |> Souscategorie.changeset(params)
          |> Repo.insert()
      end
    end
  end

  def deletes do
    Repo.delete_all(Souscategories)
    File.rm_rf(Path.expand("assets/static/images/scat"))
  end

  def insert_scat do
    if File.exists?(Path.expand("assets/static/images/scat")) do
      :ok
    else
      {:ok, File.mkdir(Path.expand("assets/static/images/scat"))}
    end
    queri = Repo.all(from a in Souscategories,
      select: a.id_souscat)
      if queri == [] do
        {:ok, souscategorie} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption, ItemFamilyId FROM ItemSubFamily")
        for sc <- souscategorie.rows do
          {:ok, subfamilyid} = Enum.fetch(sc, 0)
          {:ok, nom} = Enum.fetch(sc, 1)
          {:ok, familyid} = Enum.fetch(sc, 2)
          {:ok, image} = Ecto.Adapters.SQL.query(EBPRepo, "SELECT ItemImage FROM Item WHERE (FamilyId = '#{familyid}' AND SubFamilyId = '#{subfamilyid}') AND AllowPublishOnWeb = 1")
          {:ok, texte} = Ecto.Adapters.SQL.query(EBPRepo, "SELECT Id FROM Item WHERE FamilyId = '#{familyid}' AND SubFamilyId = '#{subfamilyid}'")
          if image.rows != [] do
            photo = Enum.random(image.rows)
            nom_image = Enum.random(texte.rows)
              File.write(Path.expand("assets/static/images/scat/#{nom_image}1.jpeg"), photo, [:binary])
              params = %{
                "id_souscat" => subfamilyid,
                "nom_souscat" => nom,
                "id_cat" => familyid,
                "photolink" => "/images/scat/#{nom_image}1.jpeg"
              }
              %Souscategories{}
                |> Souscategories.changeset(params)
                |> Repo.insert()
          else
            params = %{
              "id_souscat" => subfamilyid,
              "nom_souscat" => nom,
              "id_cat" => familyid,
              "photolink" => "/images/empty.png"
            }
            %Souscategories{}
              |> Souscategories.changeset(params)
              |> Repo.insert()
          end
        end
    else
      liste = Enum.join(queri, "','")
      {:ok, souscategorie} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption, ItemFamilyId FROM ItemSubFamily WHERE Id NOT IN ('#{liste}')")
      for sc <- souscategorie.rows do
        {:ok, subfamilyid} = Enum.fetch(sc, 0)
        {:ok, nom} = Enum.fetch(sc, 1)
        {:ok, familyid} = Enum.fetch(sc, 2)
        {:ok, image} = Ecto.Adapters.SQL.query(EBPRepo, "SELECT ItemImage FROM Item WHERE (FamilyId = '#{familyid}' AND SubFamilyId = '#{subfamilyid}') AND AllowPublishOnWeb = 1")
        {:ok, texte} = Ecto.Adapters.SQL.query(EBPRepo, "SELECT Id FROM Item WHERE FamilyId = '#{familyid}' AND SubFamilyId = '#{subfamilyid}'")
        if image.rows != [] do
          photo = Enum.random(image.rows)
          nom_image = Enum.random(texte.rows)
            File.write(Path.expand("assets/static/images/scat/#{nom_image}1.jpeg"), photo, [:binary])
            params = %{
              "id_souscat" => subfamilyid,
              "nom_souscat" => nom,
              "id_cat" => familyid,
              "photolink" => "/images/scat/#{nom_image}1.jpeg"
            }
            %Souscategories{}
              |> Souscategories.changeset(params)
              |> Repo.insert()
        else
          params = %{
            "id_souscat" => subfamilyid,
            "nom_souscat" => nom,
            "id_cat" => familyid,
            "photolink" => "/images/empty.png"
          }
          %Souscategories{}
            |> Souscategories.changeset(params)
            |> Repo.insert()
        end
      end
    end
  end

  defp si_pareil(obj_origin, line_EBP, line_PGSQL, obj, photo, prod_id,imageVer) do
    if line_EBP != line_PGSQL do
      if photo != nil do
      params = %{
        "photolink" => "/images/uploads/#{prod_id}.jpeg",
        "image_version" => imageVer
      }
        Repo.update(obj_origin.changeset(obj, params))
        File.write(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"), photo, [:binary])
        IO.puts("Photo non null")
       # :ok
      else
        params = %{
          "photolink" => "/images/empty.png",
          "image_version" => imageVer
        }
        Repo.update(obj_origin.changeset(obj, params))
        IO.puts("Photo null")
      end
    else
      IO.puts("Valeurs egaux")
    end
  end

  defp compare_allow(obj_origin, line_name, line_EBP, line_PGSQL, obj) do
    if line_EBP != line_PGSQL do
      params = %{
        "#{line_name}" => line_EBP
      }
      Repo.delete(obj_origin.changeset(obj, params))
      :ok
    else
      IO.puts("Valeurs egaux")
    end
  end

  defp si_pareils(obj_origin, line_name, line_EBP, line_PGSQL, obj) do
    if line_EBP != line_PGSQL do
      params = %{
        "#{line_name}" => line_EBP
      }
      Repo.update(obj_origin.changeset(obj, params))
      :ok
    else
      IO.puts("Valeurs egaux")
    end
  end

  def mod_prod do
      {:ok, queri} = EBPRepo.query("SELECT Item.Id,Item.SalePriceVatExcluded,Item.Caption,Item.AllowPublishOnWeb,Item.RealStock FROM Item")
      for c <- queri.rows do
        {:ok, prod_id} = Enum.fetch(c, 0)
        {:ok, prix} = Enum.fetch(c, 1)
        {:ok, capt} = Enum.fetch(c, 2)
        {:ok, afficher} = Enum.fetch(c, 3)
        {:ok, stock_max} = Enum.fetch(c, 4)

          produit = Repo.one(from p in Produit, where: p.id_produit == ^prod_id, select: p)
          if afficher == true do
            if produit != nil do
              si_pareils(Produit, "title", capt, produit.title, produit)
              si_pareils(Produit, "stockstatus",condition_stock(stock_max), produit.stockstatus, produit)
              si_pareils(Produit, "stockmax", stock_condition(stock_max), produit.stockmax, produit)
              si_pareils(Produit, "price", prix, produit.price, produit)
            else
              IO.puts("VALEUR NULLE")
            end
          else
            if produit != nil do
              :ok
            else
              IO.puts("VALEUR NULLE")
            end
          end
    end
  end

  def modification do
    {:ok, queri} = EBPRepo.query("SELECT Item.Id,Item.ImageVersion FROM Item")
    for c <- queri.rows do
      {:ok, prod_id} = Enum.fetch(c, 0)
      {:ok, imgV} = Enum.fetch(c, 1)

      produit = Repo.one(from p in Produit, where: p.id_produit == ^prod_id, select: p)
      if produit != nil do
        if produit.imageVersion != imgV do
          {:ok, querie} = EBPRepo.query("SELECT Item.ItemImage FROM Item WHERE Item.Id = '#{produit.id_produit}'")
          for e <- querie.rows do
            {:ok, photo} = Enum.fetch(e, 0)
            if is_nil(photo) do
              params = %{
                "photolink" => "/images/empty.png",
                "image_version" => imgV
              }
              Repo.update(Produit.changeset(produit, params))
              File.rm(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"))
            else
              params = %{
                "photolink" => "/images/uploads/#{prod_id}.jpeg",
                "image_version" => imgV
              }
                Repo.update(Produit.changeset(produit, params))
                File.rm(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"))
                File.write(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"), photo, [:binary])
            end
          end
        else
          :ok
        end
      else
        IO.puts "PRODUIT NULL"
      end
    end
  end

  def mod_scat do
    {:ok, souscategorie} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption, ItemFamilyId FROM ItemSubFamily")

    for sc <- souscategorie.rows do
        {:ok, subfamilyid} = Enum.fetch(sc, 0)
        {:ok, nom} = Enum.fetch(sc, 1)
        {:ok, familyid} = Enum.fetch(sc, 2)

        souscategories = Repo.one(from p in Souscategorie, where: p.id_souscat == ^subfamilyid, select: p)
        souscategorie = Repo.one(from p in Souscategories, where: p.id_souscat == ^subfamilyid, select: p)
          if souscategories != nil do
            si_pareils(Souscategorie, "nom_souscat", nom, souscategories.nom_souscat, souscategories)
            si_pareils(Souscategories, "nom_souscat", nom, souscategories.nom_souscat, souscategorie)
          else
            IO.puts("VALEUR NULLE")
          end
    end
  end

  def mod_cat do
    {:ok, queri} = EBPRepo.query("SELECT ItemFamily.Id,ItemFamily.Caption, ItemFamily.AllowPublishOnWeb FROM ItemFamily")
    for c <- queri.rows do
      {:ok, cat_id} = Enum.fetch(c,0)
      {:ok, cat_nom} = Enum.fetch(c,1)
      {:ok, afficher} = Enum.fetch(c, 2)

      categories = Repo.one(from p in Categorie, where: p.id_cat == ^cat_id, select: p)
      if afficher == true do
        if categories != nil do
          si_pareils(Categorie, "nom_cat", cat_nom, categories.nom_cat, categories)
        else
          IO.puts("VALEUR NULLE")
        end
      else
        if categories != nil do
          :ok
        else
          IO.puts("VALEUR NULLE")
        end
      end
    end
  end

  # COMPARE THE VALUES AND DELETE THE INEXISTING IN SL SERVER

  defp del_prod do
    {:ok, querie} = EBPRepo.query("SELECT Id FROM Item WHERE AllowPublishOnWeb = 1")
    list = querie.rows
    liste = Enum.join(list, ",")
    lis = String.split(liste, ",")

    from(a in Produit, where: a.id_produit not in ^lis)
    |> Repo.delete_all
  end

  defp delete(obj, eleme) do
    {:ok, querie} = EBPRepo.query("SELECT Id FROM #{obj}")
    list = querie.rows
    liste = Enum.join(list, ",")
    lis = String.split(liste, ",")

    case eleme do
      Categorie -> from(a in Categorie, where: a.id_cat not in ^lis)
      |> Repo.delete_all
      Souscategorie -> from(a in Souscategorie, where: a.id_souscat not in ^lis)
      |> Repo.delete_all
      Souscategories -> from(a in Souscategories, where: a.id_souscat not in ^lis)
      |> Repo.delete_all
    end
  end

  def sync do
    receive do
    after
      45_000 ->
        insert_prod()
        insert_scat()
        updt_cat()
        updt_scat()
        mod_prod()
        modification()
        mod_cat()
        mod_scat()
        del_prod()
        delete("ItemFamily" , Categorie)
        delete("ItemSubFamily" , Souscategorie)
        #broadcast_change({:ok, %{}}, "synchro")
        sync()
    end
  end
end

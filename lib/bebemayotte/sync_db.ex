defmodule Bebemayotte.SyncDb do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.EBPRepo
  alias Bebemayotte.Categorie
  alias Bebemayotte.Produit
  alias Bebemayotte.Souscategorie

  @topic inspect(__MODULE__)
  def subscribe do
    Phoenix.PubSub.subscribe(Bebemayotte.PubSub, @topic)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Bebemayotte.PubSub, @topic, {__MODULE__, event, result})
  end

  # def subscribe_panier do
  #   Phoenix.PubSub.subscribe(Bebemayotte.PubSub, "topic_panier")
  # end

  # def broadcast_panier({:ok, result}, event, id) do
  #   Phoenix.PubSub.broadcast(Bebemayotte.PubSub, "topic_panier", {__MODULE__, event, result})
  # end

  def start_link do
    Task.start_link(&sync/0)
  end

  defp condition_stock(x) do
    if x <= 0, do: false, else: true
  end

  defp stock_condition(x) do
    if x > 0 , do: Decimal.to_integer(x), else: 0
  end

  defp condition_image(x, x_id) do
    if x == nil, do: "#{x_id}-0.JPG", else:  Base.encode64(x)
  end

  def del_pro do
    Repo.delete_all(Produit)
    File.rm(Path.expand("assets/static/uploads/"))
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

  def updt_prod do
      queri = Repo.all(from a in Produit,
      select: a.id_produit)
      if queri == [] do
        {:ok, quer} = EBPRepo.query("SELECT Item.FamilyId,Item.Id,Item.ItemImage,Item.SalePriceVatExcluded,Item.SubFamilyId,Item.Caption,StockItem.RealStock FROM Item INNER JOIN StockItem ON Item.Id = StockItem.ItemId WHERE Item.AllowPublishOnWeb = 1")
        for c <- quer.rows do
          {:ok, cat_id} = Enum.fetch(c, 0)
          {:ok, prod_id} = Enum.fetch(c, 1)
          {:ok, photo} = Enum.fetch(c, 2)
          {:ok, prix} = Enum.fetch(c, 3)
          {:ok, souscat_id} = Enum.fetch(c, 4)
          {:ok, capt} = Enum.fetch(c, 5)
          # {:ok, afficher} = Enum.fetch(c, 6)
          {:ok, stock_max} = Enum.fetch(c, 6)
          # {:ok, stock_reel} = Enum.fetch(c, 7)
          # IO.inspect(stock_max)

          File.write(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"), photo, [:binary])

          # if afficher == true do
            params = %{
              "id_produit" => prod_id,
              "title" => capt,
              "photolink" => "/images/uploads/#{prod_id}.jpeg",
              "id_cat" => cat_id,
              "id_souscat" => souscat_id,
              "stockstatus" => condition_stock(stock_max),
              "stockmax" => stock_condition(stock_max),
              "price" => prix,
              "id_user" => 0
            }

            %Produit{}
              |> Produit.changeset(params)
              |> Repo.insert()
          # else
          #   IO.puts("Ne pas afficher")
          # end

        end
      else
        liste1 = Enum.join(queri, "','")
        {:ok, quer} = EBPRepo.query("SELECT Item.FamilyId,Item.Id,Item.ItemImage,Item.SalePriceVatExcluded,Item.SubFamilyId,Item.Caption,StockItem.RealStock FROM Item INNER JOIN StockItem ON Item.Id = StockItem.ItemId WHERE Item.Id NOT IN ('#{liste1}') AND Item.AllowPublishOnWeb = 1")
        for c <- quer.rows do
          {:ok, cat_id} = Enum.fetch(c, 0)
          {:ok, prod_id} = Enum.fetch(c, 1)
          {:ok, photo} = Enum.fetch(c, 2)
          {:ok, prix} = Enum.fetch(c, 3)
          {:ok, souscat_id} = Enum.fetch(c, 4)
          {:ok, capt} = Enum.fetch(c, 5)
          # {:ok, afficher} = Enum.fetch(c, 6)
          {:ok, stock_max} = Enum.fetch(c, 6)
          # {:ok, stock_reel} = Enum.fetch(c, 7)

          File.write(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"), photo, [:binary])

          IO.inspect(stock_max)

          # if afficher == 1 do
            params = %{
              "id_produit" => prod_id,
              "title" => capt,
              "photolink" => "/images/uploads/#{prod_id}.jpeg",
              "id_cat" => cat_id,
              "id_souscat" => souscat_id,
              "stockstatus" => condition_stock(stock_max),
              "stockmax" => stock_condition(stock_max),
              "price" => prix,
              "id_user" => 0
            }

            %Produit{}
              |> Produit.changeset(params)
              |> Repo.insert()
          # else
          #   IO.puts("Ne pas afficher")
          # end
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

  defp si_pareil(obj_origin, line_name, line_EBP, line_PGSQL, obj, prod_id, photo) do
    if line_EBP != line_PGSQL do
      params = %{
        "#{line_name}" => line_EBP
      }
      Repo.update(obj_origin.changeset(obj, params))
      File.write(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"), photo, [:binary])
      :ok
    else
      IO.puts("Valeurs egaux")
    end
  end

  defp compare_allow(obj_origin, line_name, line_EBP, line_PGSQL, obj, prod_id) do
    if line_EBP != line_PGSQL do
      params = %{
        "#{line_name}" => line_EBP
      }
      Repo.delete(obj_origin.changeset(obj, params))
      File.rm(Path.expand("assets/static/images/uploads/#{prod_id}.jpeg"))
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
      {:ok, queri} = EBPRepo.query("SELECT Item.Id,Item.ItemImage,Item.SalePriceVatExcluded,Item.Caption,Item.AllowPublishOnWeb,StockItem.RealStock FROM Item LEFT JOIN StockItem ON Item.Id = StockItem.ItemId")
      for c <- queri.rows do
        # {:ok, cat_id} = Enum.fetch(c, 0)
        {:ok, prod_id} = Enum.fetch(c, 0)
        {:ok, photo} = Enum.fetch(c, 1)
        {:ok, prix} = Enum.fetch(c, 2)
        # {:ok, souscat_id} = Enum.fetch(c, 3)
        {:ok, capt} = Enum.fetch(c, 3)
        {:ok, afficher} = Enum.fetch(c, 4)
        {:ok, stock_max} = Enum.fetch(c, 5)
        # {:ok, stock_reel} = Enum.fetch(c, 5)

          produit = Repo.one(from p in Produit, where: p.id_produit == ^prod_id, select: p)
          if afficher == true do
            if produit != nil do
              si_pareil(Produit, "photolink", condition_image(photo,prod_id), produit.photolink, produit, prod_id, photo)
              si_pareil(Produit, "title", capt, produit.title, produit, prod_id, photo)
              si_pareil(Produit, "stockstatus",condition_stock(stock_max), produit.stockstatus, produit, prod_id, photo)
              si_pareil(Produit, "stockmax", stock_condition(stock_max), produit.stockmax, produit, prod_id, photo)
              si_pareil(Produit, "price", prix, produit.price, produit, prod_id, photo)
            else
              IO.puts("VALEUR NULLE")
            end
          else
            if produit != nil do
              compare_allow(Produit, "photolink", condition_image(photo,prod_id), produit.photolink, produit, prod_id)
              compare_allow(Produit, "title", capt, produit.title, produit, prod_id)
              compare_allow(Produit, "stockstatus",condition_stock(stock_max), produit.stockstatus, produit, prod_id)
              compare_allow(Produit, "stockmax", stock_condition(stock_max), produit.stockmax, produit, prod_id)
              compare_allow(Produit, "price", prix, produit.price, produit, prod_id)
            else
              IO.puts("VALEUR NULLE")
            end
          end
    end
  end

  #def get_image do
    #{:ok, query} = EBPRepo.query("SELECT Item.Id, Item.ItemImage FROM Item")

    #for c <- query.rows do
     # {:ok, prod_id} = Enum.fetch(c, 0)
      #{:ok, photo} = Enum.fetch(c, 1)

      #path = File.write(Path.absname("C:/Données/MGBI/Hasimbola/Bebemay_dev/priv/uploads/#{prod_id}.jpeg"), photo, [:binary])
    # {:ok, data} = Base.decode64(condition_image(photo, prod_id))
    # path = File.write!("#{List.to_string(:code.priv_dir(:bebemayotte))}/uploads/#{prod_id}.png", photo, [:binary])
    #  path = File.write(Application.app_dir(:bebemayotte, Path.join("priv/uploads", "#{prod_id}.png")), photo, [:binary])
     # IO.inspect(path)
    #end
  #end

  def mod_sccat do
    {:ok, souscategorie} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption, ItemFamilyId FROM ItemSubFamily")

    for sc <- souscategorie.rows do
        {:ok, subfamilyid} = Enum.fetch(sc, 0)
        {:ok, nom} = Enum.fetch(sc, 1)
        {:ok, familyid} = Enum.fetch(sc, 2)

        souscategories = Repo.one(from p in Souscategorie, where: p.id_souscat == ^subfamilyid, select: p)
        # si_pareil(Souscategorie, "id_souscat", subfamilyid, souscategories.id_souscat, souscategories)
        si_pareils(Souscategorie, "nom_souscat", nom, souscategories.nom_souscat, souscategories)
        # si_pareil(Souscategorie, "id_cat", familyid, souscategories.id_cat, souscategories)
    end
  end

  def mod_cat do
    {:ok, queri} = EBPRepo.query("SELECT ItemFamily.Id,ItemFamily.Caption FROM ItemFamily")
    for c <- queri.rows do
      {:ok, cat_id} = Enum.fetch(c,0)
      {:ok, cat_nom} = Enum.fetch(c,1)

      categories = Repo.one(from p in Categorie, where: p.id_cat == ^cat_id, select: p)
      # si_pareil(Categorie, "id_cat", cat_id, categories.id_cat, categories)
      si_pareils(Categorie, "nom_cat", cat_nom, categories.nom_cat, categories)

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
    File.rm(Path.expand("priv/static/uploads/"))
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
    end
  end

  def sync do
    receive do
    after
      45_000 ->
        updt_prod()
        updt_cat()
        updt_scat()
        mod_prod()
        mod_cat()
        mod_sccat()
        del_prod()
        delete("ItemFamily" , Categorie)
        delete("ItemSubFamily" , Souscategorie)
        #broadcast_change({:ok, %{}}, "synchro")
        sync()
    end
  end
end

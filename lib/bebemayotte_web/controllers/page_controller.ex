defmodule BebemayotteWeb.PageController do
  use BebemayotteWeb, :controller

  alias Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.SouscatRequette
  alias Bebemayotte.PanierRequette
  alias Bebemayotte.UserRequette
  alias Bebemayotte.Details
  alias Bebemayotte.Fonction
  alias Bebemayotte.User

  alias Bebemayotte.Mailer
  alias Bebemayotte.SyncDb
  #----------------------------------------------------------PAGE PRODUITS-------------------------------------------------------------------------------------------------------------------
  # rendue de l'accueil
  def index(conn, _params) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()

    render(conn, "index.html", categories: categories, souscategories: souscategories, search: nil)
  end

  def location(conn, _params) do
    id = Plug.Conn.get_session(conn, :user_id)
    paniers = Plug.Conn.get_session(conn, :paniers)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.LocationLive, session: %{"id_session" => 1, "user" => nil, "search" => nil, "list_panier" => paniers})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.LocationLive, session: %{"id_session" => id, "user" => id, "search" => nil, "list_panier" => paniers})
    end
  end

  # rendue des produits
  def produit(conn, _params) do
    id = Plug.Conn.get_session(conn, :user_id)
    list_panier = Plug.Conn.get_session(conn, :paniers)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => 1, "user" => nil, "cat" => nil, "souscat" => nil, "search" => nil, "list_panier" => list_panier})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => id, "user" => id, "cat" => nil, "souscat" => nil, "search" => nil, "list_panier" => list_panier})
    end
  end

  # rendue des 44
  def produit_categorie(conn, %{"cat" => cat}) do
    id = Plug.Conn.get_session(conn, :user_id)
    list_panier = Plug.Conn.get_session(conn, :paniers)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => 1, "user" => nil, "cat" => cat, "souscat" => nil, "search" => nil, "list_panier" => list_panier})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => id, "user" => id, "cat" => cat, "souscat" => nil, "search" => nil, "list_panier" => list_panier})
    end
  end

  # GET PAGE PRODUIT WITH SOUS CATEGORIE
  def produit_souscategorie(conn, %{"cat" => cat, "souscat" => souscat}) do
    id = Plug.Conn.get_session(conn, :user_id)
    list_panier = Plug.Conn.get_session(conn, :paniers)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => 1, "user" => nil, "cat" => cat, "souscat" => souscat, "search" => nil, "list_panier" => list_panier})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => id, "user" => id, "cat" => cat, "souscat" => souscat, "search" => nil, "list_panier" => list_panier})
    end
  end

  #------------------------------------------------PAGE SESSION------------------------------------------------------------------------------------------------------------------------

  # GET PAGE CONNEXION
  def connexion(conn, _params) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()

    render(conn, "connexion.html", categories: categories,souscategories: souscategories, search: nil)
  end

  def mod_password(conn, %{"password" => password}) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    identifiant = get_session(conn, :identifiant)
    user = UserRequette.get_user_by_identifiant(identifiant)
    IO.inspect user
    Bebemayotte.UserRequette.update_password(user, %{"motdepasse" => password})
    render(conn, "connexion.html", categories: categories, souscategories: souscategories, search: nil)
  end

  def user_url(conn, _, _) do
    {:ok, conn}
  end

  def send_token(conn, %{"identifiant" => identifiant}) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    user = UserRequette.get_user_identifiant(identifiant)
    user_detail = UserRequette.get_user_by_identifiant(identifiant)
    token = Bebemayotte.Token.generate_new_account_token(user)
    # verification_url = user_url(conn, :verify_email, token: token)
    verification_url = "https://bbmay.fr/verify_email?token=#{token}"
    if user_detail do
      Bebemayotte.Email.new_mail_message(identifiant, verification_url) |> Mailer.deliver_now()
      render(conn |> put_session(:identifiant , identifiant), "verifier.html", categories: categories, souscategories: souscategories, search: nil)
    else
      render(conn |> put_flash(:error, "Vous n'êtes pas encore inscrit") , "connexion.html", categories: categories, souscategories: souscategories, search: nil)
    end
  end

  def verify_email(conn, %{"token" => token}) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    with  {:ok, id_user} <- Bebemayotte.Token.verify_new_account_token(token) do
      render(conn, "update_password.html", categories: categories,souscategories: souscategories, search: nil)
    else
      _ -> render(conn, "index.html", categories: categories,souscategories: souscategories, search: nil)
    end
  end

  def verification(conn, %{"token" => token}) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    user = Plug.Conn.get_session(conn, :user)

    IO.puts "USER"
    IO.inspect user
    with  {:ok, id_user} <- Bebemayotte.Token.verify_new_account_token(token) do
      UserRequette.insert_user(user)
      conn
        |> put_flash(:info_reussi, "Inscription validé veuillez vous connecter")
        |> delete_session(:user)
        |> render("connexion.html", categories: categories,souscategories: souscategories, search: nil)
    else
      _ -> render(conn, "index.html", categories: categories,souscategories: souscategories, search: nil)
    end
  end

  def verify_email(conn, _) do
    conn
      |> put_flash(:error, "Erreur lors de la validation de l'email")
      |> redirect(to: "/")
  end

  #  session sur chaque page
  def submit_connexion(conn, %{"identifiant" => identifiant, "motdepasse" => motdepasse}) do
    case UserRequette.get_user_connexion(identifiant,motdepasse) do
      {:ok, user} ->
        case Plug.Conn.get_session(conn, :statut) do
          nil ->
            conn
              |> put_session(:info_connexion, "Vous êtes connecté en tant que #{user.prenom}, ")
              |> put_session(:user_id, user.id_user)
              |> configure_session(renew: true)
              |> redirect(to: Routes.compte_path(conn, :compte))
          "to_payer" ->
            conn
              |> put_session(:info_connexion, "Vous êtes connecté en tant que #{user.prenom}, ")
              |> put_session(:user_id, user.id_user)
              |> configure_session(renew: true)
              |> redirect(to: Routes.page_path(conn, :panier))
          "to_stripe" ->
            conn
              |> put_session(:info_connexion, "Vous êtes connecté en tant que #{user.prenom}, ")
              |> put_session(:user_id, user.id_user)
              |> configure_session(renew: true)
              |> redirect(to: Routes.compte_path(conn, :payement_en_ligne))
          "to_pay_command" ->
            conn
              |> put_session(:info_connexion, "Vous êtes connecté en tant que #{user.prenom}, ")
              |> put_session(:user_id, user.id_user)
              |> configure_session(renew: true)
              |> redirect(to: Routes.compte_path(conn, :pay_command))
        end
        {:error, :unauthorized} ->
          conn
          |> put_flash(:error_id_mdp, "Adresse e-mail ou mot de passe éronné")
          |> redirect(to: Routes.page_path(conn, :connexion))
    end
  end

  # GET PAGE INSCRIPTION
  def inscription(conn, _params) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()

    render(conn, "inscri.html", categories: categories, souscategories: souscategories, search: nil)
  end

  # enregistrements de l'inscription des clients
  def submit_inscription(conn, %{"user" => %{
    "prenom" => prenom,
    "nom" => nom,
    "pays" => pays,
    "ville" => ville,
    "telephone" => telephone,
    "codepostal" => codepostal,
    "adresseMessage" => adresseMessage,
    "motdepasse" => motdepasse
  }}) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    last_row_id = UserRequette.get_user_last_row_id()
    recup_adr = UserRequette.get_user_adresse_message(adresseMessage)
    user_email = adresseMessage
    token = Bebemayotte.Token.generate_new_account_token(adresseMessage)
    verification_url = "https://bbmay.fr/verification_email?token=#{token}"

    user = %{
      "id_user" => last_row_id,
      "nom" => nom,
      "prenom" => prenom,
      "nom_affiche" => "null",
      "nom_rue" => "null",
      "batiment" => "null",
      "pays" => pays,
      "ville" => ville,
      "identifiant" => "null",
      "adresseMessage" => adresseMessage,
      "codepostal" => codepostal,
      "telephone" => telephone,
      "motdepasse" => motdepasse,
      "nom_entreprise" => "null",
      "verified" => false
    }

    IO.inspect(user)

    cond do
      recup_adr == true ->
        conn
        |> put_flash(:error_adrMess, "Adresse de Message déja éxistant!")
        |> redirect(to: Routes.page_path(conn, :inscription))

      recup_adr == false -> #and recup_id == false ->
        Bebemayotte.Email.send_verification_mail(user_email, verification_url) |> Mailer.deliver_now()
        conn
          |> put_flash(:info_reussi, "Un mail a été envoyé à #{adresseMessage}")
          |> put_session(:user, user)
          |> render( "verifier.html", categories: categories, souscategories: souscategories, search: nil)
      # with  {:ok, id_user} <- Bebemayotte.Token.verify_new_account_token(token) do
      #   UserRequette.insert_user(user)
      #   conn
      #   |> put_flash(:info_reussi, "Création de compte terminé! Veuillez vous connectez maitenant!!")
      #   |> render("connexion.html", categories: categories,souscategories: souscategories, search: nil)
      # else
      #   _ -> render(conn, "index.html", categories: categories,souscategories: souscategories, search: nil)
      # end
    end
  end

  #--------------------------------------------------PAGE CRITIQUE ET PROPOSITION-------------------------------------------------------------------------------------------------------

  # SEND MESSAGE TO EMAIL
  # def send_message_contact(conn, %{"nom" => nom, "email" => email, "description" => description}) do
  #
  #     message = "
  #
  #         #{description}
  #
  #                     from:  #{nom}
  #
  #     "
  #     Email.new_mail_message(email, message)
  #       |>Mailer.deliver_later()
  #
  #     conn
  #       |>put_flash(:mail_message_env, "Votre message a été bien envoyé!")
  #       |>redirect(to: "/contact")
  # end

  # GET PAGE QUESTION
  def question(conn,_params) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()

    render(conn,"question.html", categories: categories, souscategories: souscategories, search: nil)
  end

  def restore_password(conn, _params) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    render(conn, "password_recovery.html", categories: categories, souscategories: souscategories, search: nil)
  end

  #-------------------------------------------------PAGE PANIER--------------------------------------------------------------------------------------------------------------------------

  # ADD PANIER
  def add_panier(conn, %{"post" => post_params}) do
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)
    # IO.puts "ITO ILAY PANIERS"
    # IO.inspect(paniers)
    case paniers do
      nil ->
        paniers = [post_params["id"]]
        quantites = [String.to_integer(post_params["quantite"])]
        conn
          |> put_session(:paniers, paniers)
          |> put_session(:quantites, quantites)
          |> redirect(to: "/ajax")
      _ ->
        if not Enum.member?(paniers, post_params["id"]) do
          paniers = paniers ++ [post_params["id"]]
          quantites = quantites ++ [String.to_integer(post_params["quantite"])]
          IO.puts "non je suis ici"
          conn
            |> put_session(:paniers, paniers)
            |> put_session(:quantites, quantites)
            |> redirect(to: "/ajax")
        else
          index = Enum.find_index(paniers, fn x -> x == post_params["id"] end)
          quantites = List.update_at(quantites, index, &(&1 - &1 + String.to_integer(post_params["quantite"])))
          IO.puts "ito no tratra farany"
          conn
            |> put_session(:paniers, paniers)
            |> put_session(:quantites, quantites)
            |> redirect(to: "/ajax")
        end
    end
  end

  def ajax(conn, _) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    render(conn, "ajax_pxrx.html", search: nil, categories: categories, souscategories: souscategories)
  end

  # DELETE PANIER
  def delete_panier(conn, %{"post" => post_params}) do
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)
    index = Enum.find_index(paniers, fn x -> x == post_params["id"] end)

    paniers = List.delete_at(paniers, index)
    quantites = List.delete_at(quantites, index)

    conn
      |> put_session(:paniers, paniers)
      |> put_session(:quantites, quantites)
      |> put_flash(:info, "Effacer correctement")
      |> put_flash(:error, "erreur d'effacement")
      |> redirect(to: "/ajax")
  end

  #-----------------------------------------------------------SEARCH--------  -----------------------------------------------------------------------------------------
  # SEARCH ALGORITHM
  def search(conn, %{"_csrf_token" => _csrf_token, "search" => search}) do
    id = Plug.Conn.get_session(conn, :user_id)
    list_panier = Plug.Conn.get_session(conn, :paniers)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => 1, "user" => nil, "cat" => nil, "souscat" => nil, "search" => search, "list_panier" => list_panier})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => id, "user" => id, "cat" => nil, "souscat" => nil, "search" => search, "list_panier" => list_panier})
    end
  end

  #------------------------------------------------------------LIVEVIEW------------------------------------------------------------------------------------------------

  # GET PANIER
  def panier(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)

    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.PanierLive, session: %{"id_session" => 1, "user" => nil, "paniers" => paniers, "quantites" => quantites})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.PanierLive, session: %{"id_session" => id, "user" => id, "paniers" => paniers, "quantites" => quantites})
    end
  end

  # GET PAGE DETAIL PPRODUIT
  def detail_produit(conn, %{"id" => id}) do
    id_session = Plug.Conn.get_session(conn, :user_id)
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)

    if id_session == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.DetailProduitLive, session: %{"id_session" => 1, "id_produit" => id, "user" => nil, "paniers" => paniers, "quantites" => quantites})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.DetailProduitLive, session: %{"id_session" => id_session, "id_produit" => id, "user" => id_session, "paniers" => paniers, "quantites" => quantites})
    end
  end

  # GET PAGE CONTACT
  def contact(conn, _params) do
    # categories = CatRequette.get_all_categorie()
    id = Plug.Conn.get_session(conn, :user_id)
    list_panier = Plug.Conn.get_session(conn, :paniers)
    if id == nil do
      LiveView.Controller.live_render(conn,  BebemayotteWeb.Live.ContactLive, session: %{"user" => nil, "list_panier" => list_panier})
    else
      LiveView.Controller.live_render(conn,  BebemayotteWeb.Live.ContactLive, session: %{"user" => id, "list_panier" => list_panier})
    end
    # render(conn, "contact.html", categories: categories, search: nil)
  end

  #GET  PAGE PAYER
  def valider_panier(conn, %{"_csrf_token" => _csrf_token, "statut" => statut}) do
    if statut == "" do
      conn
        |> put_flash(:notif, "Connectez-vous pour valider la commande")
        |> put_session(:statut, "to_payer")
        |> redirect(to: Routes.page_path(conn, :connexion))
    else
      id = Plug.Conn.get_session(conn, :user_id)
      IO.puts "ID"
      IO.inspect id
      user = UserRequette.get_user!(id)
      IO.puts "USER"
      IO.inspect user
      cond do
        user.nom_rue == "null" ->
          conn
          |> put_flash(:error, "Veuillez remplir l'adresse 1")
          |> redirect(to: Routes.compte_path(conn, :update_facturation))
        true ->
          conn
            |> redirect(to: Routes.compte_path(conn, :pay_command))
      end
    end
  end
end

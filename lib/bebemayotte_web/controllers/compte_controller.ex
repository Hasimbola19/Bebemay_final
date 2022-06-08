defmodule BebemayotteWeb.CompteController do
  use BebemayotteWeb, :controller

  alias Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.UserRequette
  alias Bebemayotte.PanierRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.Details
  alias Bebemayotte.Commandes
  alias Bebemayotte.Fonction

  # Session clients
  def compte(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      redirect(conn, to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      render(conn,"compte.html", user: user, categories: categories, search: nil)
    end
  end

  # enregistrement de la commande du client
  def commandes(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      redirect(conn, to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      render(conn,"commandes.html", user: user, categories: categories, search: nil)
    end
  end

  # GET DOWNLOAD PAGE
  def down(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      redirect(conn, to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      render(conn,"down.html", user: user, categories: categories, search: nil)
    end
  end

  # GET DETAIL PAGE
  def detail(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      redirect(conn, to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      render(conn,"detail.html", categories: categories, user: user, search: nil)
    end
  end

  # GET ADDRESS PAGE
  def adresse(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      redirect(conn, to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      render(conn,"adresse.html", user: user, categories: categories, search: nil)
    end
  end

  # FUNCTION
  defp for_update(char, new_c, bd_c, u) do
    if new_c != "" and new_c != bd_c do
      params = %{
        "#{char}" => new_c
      }
      UserRequette.update_user_query(u, params)
    end
  end

  # UPDATE COMPTE
  def update_account(conn, %{
    "prenom" => prenom,
    "nom" => nom,
    "nom_affiche" => nom_affiche,
    "adresseMessage" => adresseMessage,
    "motdepasse_actuel" => motdepasse_actuel,
    "motdepasse_new" => motdepasse_new,
    "motdepasse_new_confirm" => motdepasse_new_confirm
  }) do

    id = Plug.Conn.get_session(conn, :user_id)
    user = UserRequette.get_user_by_id(id)

    for_update("prenom", prenom, user.prenom, user)
    for_update("nom", nom, user.nom, user)
    for_update("nom_affiche", nom_affiche, user.nom_affiche, user)
    for_update("adresseMessage", adresseMessage, user.adresseMessage, user)

    if motdepasse_actuel != user.motdepasse do
      conn
        |>put_flash(:mdp_error, "Mot de passe éronné!")
        |>redirect(to: "/detail")
    else
      if motdepasse_new == user.motdepasse do
        conn
          |>put_flash(:mdp_error, "Mot de passe semblable à l'ancien!")
          |>redirect(to: "/detail")
      else
        if motdepasse_new != motdepasse_new_confirm do
          conn
            |>put_flash(:mdp_error, "Mot de passe non confirmé, le nouveau!")
            |>redirect(to: "/detail")
        else
          params = %{
            "motdepasse" => motdepasse_new
          }
          UserRequette.update_user_query(user, params)
        end
      end
    end

    conn
      |>put_flash(:info_update, "Mise à jour réussi!")
      |>redirect(to: "/detail")
  end

  # DECONNEXION
  def deconnexion(conn, %{"hidden" => hidden}) do
    IO.puts hidden
    conn
      |>configure_session(drop: true)
      |>redirect(to: "/connexion")
  end

  #------------------------------------------------------------------------------COMMAND-----------------------------------------------------------------------------------

  # SEE MY COMMAND
  def see_command(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      redirect(conn, to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      render(conn,"voir.html", user: user, categories: categories, search: nil)
    end
  end

  # CONFIDENTIALITY POLITIC
  def politique(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"politique.html", categories: categories, search: nil)
  end

  # GET PAGE FACTURATION
  def update_facturation(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      redirect(conn, to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      render(conn,"modifier.html", user: user, categories: categories, search: nil)
    end
  end

  # SUBMIT "UPDATE FACTURATION"
  def submit_update_facturation(conn, %{
    "prenom" => prenom,
    "nom" => nom,
    "nom_entreprise" => nom_entreprise,
    "nom_rue" => nom_rue,
    "batiment" => batiment,
    "ville" => ville,
    "codepostal" => codepostal,
    "telephone" => telephone,
    "adresseMessage" => adresseMessage
  }) do
    id = Plug.Conn.get_session(conn, :user_id)
    user = UserRequette.get_user_by_id(id)
    tel = Integer.to_string(telephone)

    for_update("prenom", prenom, user.prenom, user)
    for_update("nom", nom, user.nom, user)
    for_update("nom_entreprise", nom_entreprise, user.nom_entreprise, user)
    for_update("nom_rue", nom_rue, user.nom_rue, user)
    for_update("batiment", batiment, user.batiment, user)
    for_update("ville", ville, user.ville, user)
    for_update("codepostal", codepostal, user.codepostal, user)
    for_update("telephone", tel, user.telephone, user)
    for_update("adresseMessage", adresseMessage, user.adresseMessage, user)

    conn
      |>put_flash(:info_update, "Mise à jour réussi!")
      |>redirect(to: "/update_address/facturation")
  end

  # GET PAGE LIVRAISON
  def update_livraison(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      redirect(conn, to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      render(conn,"modification.html", user: user, categories: categories, search: nil)
    end
  end

  # SUBMIT "UPDATE FACTURATION"
  def submit_update_livraison(conn, %{
    "prenom" => prenom,
    "nom" => nom,
    "nom_entreprise" => nom_entreprise,
    "nom_rue" => nom_rue,
    "batiment" => batiment,
    "ville" => ville,
    "codepostal" => codepostal
  }) do
    id = Plug.Conn.get_session(conn, :user_id)
    user = UserRequette.get_user_by_id(id)

    for_update("prenom", prenom, user.prenom, user)
    for_update("nom", nom, user.nom, user)
    for_update("nom_entreprise", nom_entreprise, user.nom_entreprise, user)
    for_update("nom_rue", nom_rue, user.nom_rue, user)
    for_update("batiment", batiment, user.batiment, user)
    for_update("ville", ville, user.ville, user)
    for_update("codepostal", codepostal, user.codepostal, user)

    conn
      |>put_flash(:info_update, "Mise à jour réussi!")
      |>redirect(to: "/update_address/livraison")
  end

  # ASK EMAIL OR IDENTIFIANT
  def ask_email(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"ask_email.html", categories: categories, search: nil)
  end

  # PAY COMMAND
  def pay_command(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)

    categories = CatRequette.get_all_categorie()

    if is_nil(id) do
      conn
        |> put_flash(:notif, "Connectez-vous pour valider la commande")
        |> put_session(:statut, "to_pay_command")
        |> redirect(to: "/connexion")
    else
      user = UserRequette.get_user_by_id(id)
      details = id |> Fonction.detail_commande_show(paniers, quantites)
      prix_total = details |> Fonction.get_prix_total()
      remise = Float.round((prix_total * 5)/100, 2)
      prix_remise = prix_total - remise
      render(conn,"payer.html", user: user, categories: categories, search: nil, details: details, prix_total: prix_total, remise: remise, prix_remise: prix_remise)
    end
  end

  # VALIDER ET PAYER COMMANDE
    # VALIDER ET PAYER COMMANDE
    def validation(conn,_params) do
      categories = CatRequette.get_all_categorie()
      id = Plug.Conn.get_session(conn, :user_id)
      paniers = Plug.Conn.get_session(conn, :paniers)
      quantites = Plug.Conn.get_session(conn, :quantites)
      details = id |> Fonction.detail_commande_show(paniers, quantites)
      prix_total = details |> Fonction.get_prix_total()
      remise = Float.round((prix_total * 5)/100, 2)
      # prix_remise = prix_total - remise
      num_commande = id |> Fonction.fn_2()
      date = NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      mail = UserRequette.get_user_email_by_id(id)

      commande = %{
        "numero" => num_commande,
        "total" => prix_total,
        "date" => date
      }

      pbx_site = "2366513" #"1999888"
      pbx_rang = "01" #"32"
      pbx_identifiant = "122909322" #"123456789"
      # total = "200"
      tot = Float.floor(prix_total, 2)
      total = tot |> to_string()
      IO.puts "TOOOOOOOOOOOOTTTTTTTTTTTTAAAAAAAAAAAALLLLLLLLLL"
      # IO.inspect "#{total}0"
      IO.puts "LLLLOOOOONNNNNNNNNNNNGGGGGGGGG"
      IO.inspect String.length(total)

      pbx_cmd = num_commande
      pbx_porteur = mail

      # // Paramétrage de l'url de retour back office site (notification de paiement IPN) :
      pbx_repondre_a = "http://www.votre-site.extention/page-de-back-office-site";

      # // Paramétrage des données retournées via l'IPN :
      pbx_retour = "Mt:M;Ref:R;Auto:A;Erreur:E";

      # // Paramétrage des urls de redirection navigateur client après paiement :
      pbx_effectue = "http://162.19.74.21:4001"
      pbx_annule = "http://162.19.74.21:4001/produit"
      pbx_refuse = "http://162.19.74.21:4001"

      # // On récupère la date au format ISO-8601 :
      {erl_date, erl_time} = :calendar.local_time()

      {:ok, time} = Time.from_erl(erl_time)

      {:ok, daty} = Date.from_erl(erl_date)

      heure =  Calendar.strftime(time, "%c", preferred_datetime: "%H:%M:%S")

      dat = Calendar.strftime(daty, "%c", preferred_datetime: "%Y-%m-%d")

      pbx_time = "#{dat}T#{heure}+02:00"

      # // Nombre de produit envoyé dans PBX_SHOPPINGCART :
      pbx_nb_produit = Enum.count(quantites)
      # pbx_nb_produit = "5"
      IO.inspect pbx_nb_produit
      # // Construction de PBX_SHOPPINGCART :
      pbx_shoppingcart =
         "<?xml version=\"1.0\" encoding=\"utf-8\"?><shoppingcart><total><totalQuantity>#{pbx_nb_produit}</totalQuantity></total></shoppingcart>"
      # // Valeurs envoyées dans PBX_BILLING :
      pbx_prenom_fact = "Jean-Marie"						#	//variable de test Jean-Marie
      pbx_nom_fact = "Thomson"
      pbx_hash = "sha512"
      # // --------------- SÉLÉCTION DE L'ENVIRRONEMENT ---------------
      # // Recette (paiements de test)  :
          urletrans = "https://recette-tpeweb.e-transactions.fr/php/"

      # // Production (paiements réels) :
        # // URL principale :
          # urletrans ="https://tpeweb.e-transactions.fr/php/";
        # // URL secondaire :
          #urletrans ="https://tpeweb1.e-transactions.fr/php/";

      pbx_adresse1_fact = "1 rue de Paris";								#//variable de test 1 rue de Paris
      pbx_adresse2_fact = "";								#//variable de test <vide>
      pbx_zipcode_fact = "75001";						#	//variable de test 75001
      pbx_city_fact = "Paris";									#//variable de test Paris
      pbx_country_fact = "250";		#//variable de test 250 (pour la France)

      pbx_billing =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><Billing><Address><FirstName>#{pbx_prenom_fact}</FirstName>"<>""<>
          "<LastName>#{pbx_nom_fact}</LastName><Address1>#{pbx_adresse1_fact}</Address1>"<>""<>
          "<Addresse2>#{pbx_adresse2_fact}</Addresse2><ZipCode>#{pbx_zipcode_fact}</ZipCode>"<>""<>
          "<City>#{pbx_city_fact}</City><CountryCode>#{pbx_country_fact}</CountryCode>"<>""<>
          "</Address></Billing>"

      hmackey = "56A05997B9149BFDE3B07BEAFC2BD55FE50321CF3CF5A6623E727A4124CB0999D9590C6D02E036365363E746FE34C3F04F80EF110ABE294A9CD3877F36B38BAE"
        # "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF"

      binkey = hmackey |> Base.decode16!()

      if String.length(total) <= 4 do
        pbx_total = "#{total}0" |> String.replace(",", "") |> String.replace(".", "")
        msg = "PBX_SITE=#{pbx_site}"<>""<>
        "&PBX_RANG=#{pbx_rang}"<>""<>
        "&PBX_IDENTIFIANT=#{pbx_identifiant}"<>""<>
        "&PBX_TOTAL=#{pbx_total}"<>""<>
        "&PBX_DEVISE=978"<>""<>
        "&PBX_CMD=#{pbx_cmd}"<>""<>
        "&PBX_PORTEUR=#{pbx_porteur}"<>""<>
        "&PBX_REPONDRE_A=#{pbx_repondre_a}"<>""<>
        "&PBX_RETOUR=#{pbx_retour}"<>""<>
        "&PBX_EFFECTUE=#{pbx_effectue}"<>""<>
        "&PBX_ANNULE=#{pbx_annule}"<>""<>
        "&PBX_REFUSE=#{pbx_refuse}"<>""<>
        "&PBX_HASH=SHA512"<>""<>
        "&PBX_TIME=#{pbx_time}"<>""<>
        "&PBX_SHOPPINGCART=#{pbx_shoppingcart}"<>""<>
        "&PBX_BILLING=#{pbx_billing}"

        hmac = :crypto.mac(:hmac, :sha512, binkey, msg)
        |> Base.encode16()
        |> String.upcase()

        if prix_total == nil do
          render(conn,"validation.html",
            categories: categories,
            commande: commande,
            search: nil,
            statut_commande: 0,
            pbx_site: pbx_site,
            pbx_rang: pbx_rang,
            pbx_identifiant: pbx_identifiant,
            pbx_total: pbx_total,
            pbx_cmd: pbx_cmd,
            pbx_porteur: pbx_porteur,
            pbx_repondre_a: pbx_repondre_a,
            pbx_retour: pbx_retour,
            pbx_effectue: pbx_effectue,
            pbx_annule: pbx_annule,
            pbx_refuse: pbx_refuse,
            pbx_hash: pbx_hash,
            pbx_time: pbx_time,
            pbx_shoppingcart: pbx_shoppingcart,
            pbx_billing: pbx_billing,
            hmac: hmac,
            msg: msg,
            urletrans: urletrans
          )
        else
          render(conn,"validation.html",
          categories: categories,
          commande: commande,
          search: nil,
          statut_commande: 1,
          pbx_site: pbx_site,
          pbx_rang: pbx_rang,
          pbx_identifiant: pbx_identifiant,
          pbx_total: pbx_total,
          pbx_cmd: pbx_cmd,
          pbx_porteur: pbx_porteur,
          pbx_repondre_a: pbx_repondre_a,
          pbx_retour: pbx_retour,
          pbx_effectue: pbx_effectue,
          pbx_annule: pbx_annule,
          pbx_refuse: pbx_refuse,
          pbx_hash: pbx_hash,
          pbx_time: pbx_time,
          pbx_shoppingcart: pbx_shoppingcart,
          pbx_billing: pbx_billing,
          hmac: hmac,
          msg: msg,
          urletrans: urletrans
          )
        end
      else
        pbx_total = total |> String.replace(",", "") |> String.replace(".", "")
        msg = "PBX_SITE=#{pbx_site}"<>""<>
        "&PBX_RANG=#{pbx_rang}"<>""<>
        "&PBX_IDENTIFIANT=#{pbx_identifiant}"<>""<>
        "&PBX_TOTAL=#{pbx_total}"<>""<>
        "&PBX_DEVISE=978"<>""<>
        "&PBX_CMD=#{pbx_cmd}"<>""<>
        "&PBX_PORTEUR=#{pbx_porteur}"<>""<>
        "&PBX_REPONDRE_A=#{pbx_repondre_a}"<>""<>
        "&PBX_RETOUR=#{pbx_retour}"<>""<>
        "&PBX_EFFECTUE=#{pbx_effectue}"<>""<>
        "&PBX_ANNULE=#{pbx_annule}"<>""<>
        "&PBX_REFUSE=#{pbx_refuse}"<>""<>
        "&PBX_HASH=SHA512"<>""<>
        "&PBX_TIME=#{pbx_time}"<>""<>
        "&PBX_SHOPPINGCART=#{pbx_shoppingcart}"<>""<>
        "&PBX_BILLING=#{pbx_billing}"

        hmac = :crypto.mac(:hmac, :sha512, binkey, msg)
        |> Base.encode16()
        |> String.upcase()

        if prix_total == nil do
          render(conn,"validation.html",
            categories: categories,
            commande: commande,
            search: nil,
            statut_commande: 0,
            pbx_site: pbx_site,
            pbx_rang: pbx_rang,
            pbx_identifiant: pbx_identifiant,
            pbx_total: pbx_total,
            pbx_cmd: pbx_cmd,
            pbx_porteur: pbx_porteur,
            pbx_repondre_a: pbx_repondre_a,
            pbx_retour: pbx_retour,
            pbx_effectue: pbx_effectue,
            pbx_annule: pbx_annule,
            pbx_refuse: pbx_refuse,
            pbx_hash: pbx_hash,
            pbx_time: pbx_time,
            pbx_shoppingcart: pbx_shoppingcart,
            pbx_billing: pbx_billing,
            hmac: hmac,
            msg: msg,
            urletrans: urletrans
          )
        else
          render(conn,"validation.html",
          categories: categories,
          commande: commande,
          search: nil,
          statut_commande: 1,
          pbx_site: pbx_site,
          pbx_rang: pbx_rang,
          pbx_identifiant: pbx_identifiant,
          pbx_total: pbx_total,
          pbx_cmd: pbx_cmd,
          pbx_porteur: pbx_porteur,
          pbx_repondre_a: pbx_repondre_a,
          pbx_retour: pbx_retour,
          pbx_effectue: pbx_effectue,
          pbx_annule: pbx_annule,
          pbx_refuse: pbx_refuse,
          pbx_hash: pbx_hash,
          pbx_time: pbx_time,
          pbx_shoppingcart: pbx_shoppingcart,
          pbx_billing: pbx_billing,
          hmac: hmac,
          msg: msg,
          urletrans: urletrans
          )
        end
      end
      # // Suppression des points ou virgules dans le montant

    end
  #def valid_pay_command(conn,)

  # PAYEMENT EN LIGNE

  def to_stripe(conn, %{"_csrf_token" => _csrf_token}) do
    conn
      |> redirect(to: "/validation")
  end

  def validate_command(conn, %{"_csrf_token" => _csrf_token}) do
    IO.puts("ITO ILAY TOKEN")
    # IO.inspect(csrf_token)
    id = Plug.Conn.get_session(conn, :user_id)
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)
    details = id |> Fonction.detail_commande_show(paniers, quantites)
    prix_total = details |> Fonction.get_prix_total()
    remise = Float.round((prix_total * 5)/100, 2)
    prix_remise = prix_total - remise
    num_commande = id |> Fonction.fn_2()
    date = NaiveDateTime.local_now() |> NaiveDateTime.to_date()

    if Commandes.find_double_commande(num_commande) do
      commande = %{
        "id_user" => id,
        "numero" => num_commande,
        "total" => prix_remise,
        "date" => date,
        "statut" => false
      }
      commande |> Commandes.create_commande()
    end
    details
      |> Enum.map(
            fn x ->
              params = %{
                "id_commande" => Details.get_detailcommandes_last_row_id(),
                "quantite" => x["quantite"],
                "nom_produit" => x["nom_produit"],
                "numero" => num_commande,
                "id_user" => id,
                "prix" => x["prix"]
              }
              if Details.find_double_detailcommandes(x["nom_produit"], x["id_user"]) do
                params |> Details.create_detailcommandes
              end
            end
         )
    conn
      |> redirect(external: "http://localhost:4001/produit")#"http://localhost:4010/ito/ito")
  end

  def payement_en_ligne(conn, _) do
    id = Plug.Conn.get_session(conn, :user_id)
    num_commande = Plug.Conn.get_session(conn, :numero_commande)

    if is_nil(id) do
      conn
        |> put_flash(:notif, "Connectez-vous pour valider la commande")
        |> put_session(:statut, "to_stripe")
        |> redirect(to: Routes.page_path(conn, :connexion))
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.CheckoutLive.Payement, session: %{"id_session" => id, "num_commande" => num_commande})
    end
  end
end

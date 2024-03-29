defmodule Bebemayotte.UserRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.User

  def get_all_user do
    Repo.all(User)
  end

  def get_user!(id) do
    query = from us in User,
      where: us.id_user == ^id,
      select: us
    Repo.one(query)
  end

  def get_user_by_email(identifiant) do
    query = from us in User,
      where: us.adresseMessage == ^identifiant,
      select: us
    Repo.one(query)
  end

  def get_user_by_identifiant(identifiant) do
    query = from u in User,
    where: u.adresseMessage == ^identifiant,
    select: u
     user = Repo.one(query)
    case user do
      nil -> false
      _ -> user
    end
  end

  # GET USER
  def get_user_identifiant(identif) do
    query =
          from u in User,
            where: u.identifiant == ^identif,
            select: u.id

    id = Repo.one(query)

    case id do
      nil -> false
      _ -> id
    end
  end

  def update_hash_password() do
    query = Repo.all(from us in User,
    select: us)
    for u <- query do
      if String.contains?(u.motdepasse, "pbkdf2") do
        IO.puts "Tsisy"
      else
        IO.puts "LISTE BE A"
        IO.puts "FIN LISTE BE"
        mdp = Pbkdf2.hash_pwd_salt(u.motdepasse)
        Repo.update(User.changeset_uptade_password(u, %{"motdepasse" => mdp}))
      end
    end
  end

  def update_password(user, params) do
    user
      |> User.update_password_changeset(params)
      |> Repo.update()
  end

  def get_user_email_by_id(id) do
    query =
      from co in User,
        where: co.id_user == ^id,
        select: co.adresseMessage
    Repo.one(query)
  end

  def get_user_rue_by_id(id)do
    query =
      from co in User,
        where: co.id_user == ^id,
        select: co.nom_rue
    Repo.one(query)
  end

  def get_user_name_by_id(id) do
    query =
      from co in User,
        where: co.id_user == ^id,
        select: co.nom
    Repo.one(query)
  end

  def get_user_prename_by_id(id) do
    query =
      from co in User,
        where: co.id_user == ^id,
        select: co.prenom
    Repo.one(query)
  end

  def get_user_pays_by_id(id) do
    query =
      from co in User,
        where: co.id_user == ^id,
        select: co.pays
    Repo.one(query)
  end

  def get_user_codepostal_by_id(id) do
    query =
      from co in User,
        where: co.id_user == ^id,
        select: co.codepostal
    Repo.one(query)
  end

  def get_user_ville_by_id(id) do
    query =
      from co in User,
        where: co.id_user == ^id,
        select: co.ville
    Repo.one(query)
  end

  def get_user_nom_rue_by_id(id) do
    query =
      from us in User,
        where: us.id_user == ^id,
        select: us.nom_rue
    Repo.one(query)
  end

  def get_user_telephone_by_id(id) do
    query =
      from u in User,
      where: u.id_user == ^id,
      select: u.telephone
    tel = Repo.one(query)
      case tel do
        nil -> ""
        _ -> tel
      end
  end

  def get_user_adresse_message(adrMess) do
    query =
      from u in User,
        where: u.adresseMessage == ^adrMess,
        select: u.id

    id = Repo.one(query)

    case id do
      nil -> false
      _ -> true
    end
  end

  def letters_date_format_with_hours(naive_dt) do
    Calendar.strftime(naive_dt,"%A %d %B %Y, %Hh %M",
       day_of_week_names: fn day_of_week ->
         {"Lundi", "Mardi", "Mercredi", "Jeudi",
         "Vendredi", "Samedi", "Dimanche"}
         |> elem(day_of_week - 1)
       end,
       month_names: fn month ->
         {"Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
         "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"}
         |> elem(month - 1)
       end
      )
  end

  # INSERT USER
  def insert_user(params) do
    %User{}
    |>User.changeset(params)
    |>Repo.insert()
  end

  # UPDATE USER
  def update_user_query(user, params) do
    user
      |>User.changeset(params)
      |>Repo.update()
  end

  # GET LAST ROW ID
  def get_user_last_row_id() do
    query =
      from u in User,
        limit: 1,
        order_by: [desc: u.id_user],
        select: u.id_user
    id = Repo.one(query)
    case is_nil(id) do
      true -> 1
      false -> id + 1
    end
  end

  # GET USER CONNEXION
  def get_user_connexion(ident, mdp) do
    query =
      from u in User,
        where: (u.adresseMessage == ^ident) and u.motdepasse == ^mdp,
        select: u

    user = Repo.one(query)
    case user do
      %User{} -> {:ok, user}
      nil -> {:error, :unauthorized}
    end
  end

  # GET USER BY ID
  def get_user_by_id(id) do
    query =
      from u in User,
        where: u.id_user == ^id,
        select: u
    Repo.one(query)
  end

  def delete_user_by_name() do
    query = Repo.one(from u in User,
      where: u.adresseMessage == "rakotosonhasina00@gmail.com",
      select: u)
     query
      |> Repo.delete()
  end

end

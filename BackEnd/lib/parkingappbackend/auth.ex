defmodule Parkingappbackend.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Parkingappbackend.Repo
  alias Parkingappbackend.Guardian
  alias Parkingappbackend.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_username(username) do
    query = from u in User, where: u.username == ^username
    Repo.one(query)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def update_user_password(%User{} = user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate_user(username, password) do
        query = from(u in User, where: u.username == ^username)
        username = Repo.one(query)
        verify_password(username, password)
      end

      defp verify_password(nil, _) do
        # Perform a dummy check to make user enumeration more difficult
        Pbkdf2.no_user_verify()
        {:error, "Wrong username or password"}
      end

      defp verify_password(user, password) do
        if Pbkdf2.verify_pass(password, user.password_hash) do
        {:ok, user}
        else
          {:error, "Wrong username or password"}
        end
      end

      def token_sign_in(username, password) do
        case authenticate_user(username, password) do
          {:ok, user} ->
            Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
          _ ->
            {:error, :unauthorized}
        end
      end

end

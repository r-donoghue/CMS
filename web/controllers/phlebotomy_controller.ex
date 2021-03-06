defmodule Cmsv1.PhlebotomyController do
  use Cmsv1.Web, :controller

  import Ecto.Changeset

  alias Cmsv1.Phlebotomy
  alias Cmsv1.Patient

  def index(conn, _params) do
    phleb = Repo.all(Phlebotomy)
    patients = Repo.all(Patient) 
    render(conn, "index.html", phleb: phleb, patients: patients)
  end

  def new(conn, _params) do
    changeset = Phlebotomy.changeset(%Phlebotomy{})

    patients = Repo.all(Patient) |> Enum.map(&{&1.fname<>" "<>&1.lname, &1.patient_id}) |> Enum.into(%{}) 
    render(conn, "new.html", changeset: changeset, patients: patients)
  end

  def create(conn, %{"phlebotomy" => phlebotomy_params}) do
    changeset = Phlebotomy.changeset(%Phlebotomy{}, phlebotomy_params)

    patients = Repo.all(Patient) |> Enum.map(&{&1.fname, &1.patient_id}) |> Enum.into(%{}) 

    clinic = get_session(conn, :clinic_id)
    changeset = change(changeset, %{clinic_id: clinic})

    case Repo.insert(changeset) do
      {:ok, _phlebotomy} ->
        conn
        |> put_flash(:info, "Phlebotomy created successfully.")
        |> redirect(to: phlebotomy_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, patients: patients)
    end
  end

  def show(conn, %{"id" => id}) do
    phlebotomy = Repo.get!(Phlebotomy, id)
    patients = Repo.all(Patient) 
    render(conn, "show.html", phlebotomy: phlebotomy, patients: patients)
  end

  def edit(conn, %{"id" => id}) do
    phlebotomy = Repo.get!(Phlebotomy, id)
    patients = Repo.all(Patient) |> Enum.map(&{&1.fname<>" "<>&1.lname, &1.patient_id}) |> Enum.into(%{}) 
    changeset = Phlebotomy.changeset(phlebotomy)
    render(conn, "edit.html", phlebotomy: phlebotomy, changeset: changeset, patients: patients)
  end

  def update(conn, %{"id" => id, "phlebotomy" => phlebotomy_params}) do
    phlebotomy = Repo.get!(Phlebotomy, id)
    changeset = Phlebotomy.changeset(phlebotomy, phlebotomy_params)

    case Repo.update(changeset) do
      {:ok, phlebotomy} ->
        conn
        |> put_flash(:info, "Phlebotomy updated successfully.")
        |> redirect(to: phlebotomy_path(conn, :show, phlebotomy))
      {:error, changeset} ->
        render(conn, "edit.html", phlebotomy: phlebotomy, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    phlebotomy = Repo.get!(Phlebotomy, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(phlebotomy)

    conn
    |> put_flash(:info, "Phlebotomy deleted successfully.")
    |> redirect(to: phlebotomy_path(conn, :index))
  end

  plug :authenticate when action in [:index, :show, :new, :edit, :update, :delete]

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
    conn
    else
    conn
    |> put_flash(:error, "You must be logged in to access that page")
    |> redirect(to: session_path(conn, :new))
    |> halt()
    end
    end
end

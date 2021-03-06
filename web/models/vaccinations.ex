defmodule Cmsv1.Vaccinations do
  use Cmsv1.Web, :model

  @primary_key {:vacc_id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :vacc_id}

  schema "vaccs" do
    field :vacc_brand, :string
    field :dose1_status, :boolean, default: false
    field :dose1_date, Ecto.Date
    field :dose2_status, :boolean, default: false
    field :dose2_date, Ecto.Date
    field :dose3_status, :boolean, default: false
    field :dose3_date, Ecto.Date
    field :hbs_status, :boolean, default: false
    field :hbs_result, :string
    field :revacc_status, :boolean, default: false
    field :revacc_date, Ecto.Date
    field :revacc_type, :string
    field :booster_date, Ecto.Date
    field :booster_dose, :string
    belongs_to :clinics, Cmsv1.Clinic, foreign_key: :clinic_id, type: :binary_id, references: :clinic_id
    belongs_to :patients, Cmsv1.Patient, foreign_key: :patient_id, type: :binary_id, references: :patient_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:patient_id, :vacc_brand, :dose1_status, :dose1_date, :dose2_status, :dose2_date, :dose3_status, :dose3_date, :hbs_status, :hbs_result, :revacc_status, :revacc_type, :booster_date, :booster_dose, :clinic_id])
    |> validate_required([:vacc_brand, :dose1_status, :dose2_status, :dose3_status, :hbs_status, :revacc_status])
    |> foreign_key_constraint(:patient_id)
    |> foreign_key_constraint(:clinic_id)
  end
end

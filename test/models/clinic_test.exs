defmodule Cmsv1.ClinicTest do
  use Cmsv1.ModelCase

  alias Cmsv1.Clinic

  @valid_attrs %{address: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Clinic.changeset(%Clinic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Clinic.changeset(%Clinic{}, @invalid_attrs)
    refute changeset.valid?
  end
end

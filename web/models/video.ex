defmodule PhoenixVideoStream.Video do
  use PhoenixVideoStream.Web, :model

  schema "vidos" do
    field :title, :string
    field :video_file, :any, virtual: true
    field :filename, :string
    field :content_type, :string
    field :path, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @required_fields ~w(title video_file)
  @optional_fields ~w(filename content_type path)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> put_video_file()
  end

  def put_video_file(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{video_file: video_file}} ->
        path = Ecto.UUID.generate() <> Path.extname(video_file.filename)
        changeset
        |> put_change(:path, path)
        |> put_change(:filename, video_file.filename)
        |> put_change(:content_type, video_file.content_type)
      _ ->
        changeset
    end

  end
end

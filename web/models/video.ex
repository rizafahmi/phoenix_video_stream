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
  @required_fields ~w(title path)
  @optional_fields ~w(filename content_type video_file)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> put_video_metadata()
  end

  def put_video_metadata(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{path: path}} ->
        content_type = get_file_type(path)
        changeset
        |> put_change(:filename, path)
        |> put_change(:content_type, content_type)
      _ ->
        changeset
    end

  end

  defp get_file_type(path) do
    extraction = String.split(path, ".")
    extension = Enum.at(extraction, -1)
    case extension do
      "mkv" -> "video/webm"
      _ -> "video/" <> extension
    end
  end
end

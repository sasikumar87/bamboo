defmodule Bamboo.Attachment do
  @moduledoc """
  """

  defstruct filename: nil, content_type: nil, path: nil, data: nil

  @doc ~S"""
  Creates a new Attachment

  Examples:
    Attachment.new_from_file("/path/to/attachment.png")
    Attachment.new_from_file("/path/to/attachment.png", filename: "image.png")
    Attachment.new_from_file("/path/to/attachment.png", filename: "image.png", content_type: "image/png")
    Attachment.new_from_file(params["file"]) # Where params["file"] is a %Plug.Upload
  """
  def new_from_file(path, opts \\ [])
  if Code.ensure_loaded?(Plug) do
    def new_from_file(%Plug.Upload{filename: filename, content_type: content_type, path: path}, opts), do:
      new_from_file(path, Keyword.merge([filename: filename, content_type: content_type], opts))
  end
  def new_from_file(path, opts) do
    filename = opts[:filename] || Path.basename(path)
    content_type = opts[:content_type] || determine_content_type(path)
    data = File.read!(path)
    %__MODULE__{path: path, data: data, filename: filename, content_type: content_type}
  end

  defp determine_content_type(path) do
    if Code.ensure_loaded?(Plug) do
      Plug.MIME.path(path)
    else
      "application/octet-stream"
    end
  end
end

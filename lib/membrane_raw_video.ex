defmodule Membrane.RawVideo do
  @moduledoc """
  This module provides a struct (`t:#{inspect(__MODULE__)}.t/0`) describing raw video frames.
  """
  require Integer

  @typedoc """
  Width of single frame in pixels.
  """
  @type width :: pos_integer()

  @typedoc """
  Height of single frame in pixels.
  """
  @type height :: pos_integer()

  @typedoc """
  Number of frames per second. To avoid using floating point numbers,
  it is described by 2 integers number of frames per timeframe in seconds.

  For example, NTSC's framerate of ~29.97 fps is represented by `{30_000, 1001}`.
  If the information about the framerate is not present in the stream, `nil` value
  should be used and the buffers described by this stream format must have non-nil timestamps.
  """
  @type framerate :: {frames :: non_neg_integer, seconds :: pos_integer} | nil

  @typedoc """
  Format used to encode the color of every pixel in each video frame.
  """
  @type pixel_format ::
          :I420
          | :I422
          | :I444
          | :RGB
          | :BGR
          | :BGRA
          | :RGBA
          | :NV12
          | :NV21
          | :YV12
          | :AYUV
          | :YUY2
          | :I420_10LE
          | :I420_10BE
          | :I422_10LE
          | :I422_10BE
          | :I444_10LE
          | :I444_10BE

  @typedoc """
  Determines, whether buffers are aligned i.e. each buffer contains one frame.
  """
  @type aligned :: boolean()

  @type t :: %__MODULE__{
          width: width(),
          height: height(),
          framerate: framerate(),
          pixel_format: pixel_format(),
          aligned: aligned()
        }

  @enforce_keys [:width, :height, :framerate, :pixel_format, :aligned]
  defstruct @enforce_keys

  @supported_pixel_formats [
    :I420,
    :I422,
    :I444,
    :RGB,
    :BGR,
    :BGRA,
    :RGBA,
    :NV12,
    :NV21,
    :YV12,
    :AYUV,
    :YUY2,
    :I420_10LE,
    :I420_10BE,
    :I422_10LE,
    :I422_10BE,
    :I444_10LE,
    :I444_10BE
  ]

  @doc """
  Simple wrapper over `frame_size/3`. Returns the size of raw video frame
  in bytes for the given raw video stream format.
  """
  @spec frame_size(t()) :: {:ok, pos_integer()} | {:error, reason}
        when reason: :invalid_dimensions | :invalid_pixel_format
  def frame_size(%__MODULE__{pixel_format: format, width: width, height: height}) do
    frame_size(format, width, height)
  end

  @doc """
  Returns the size of raw video frame in bytes (without padding).

  It may result in error when dimensions don't fulfill requirements for the given format
  (e.g. I420 requires both dimensions to be divisible by 2).
  """
  @spec frame_size(pixel_format(), width(), height()) ::
          {:ok, pos_integer()} | {:error, reason}
        when reason: :invalid_dimensions | :invalid_pixel_format
  def frame_size(format, width, height)
      when format in [:I420, :YV12, :NV12, :NV21] and Integer.is_even(width) and
             Integer.is_even(height) do
    # Subsampling by 2 in both dimensions
    # Y = width * height
    # V = U = (width / 2) * (height / 2)
    {:ok, div(width * height * 3, 2)}
  end

  def frame_size(format, width, height)
      when format in [:I422, :YUY2] and Integer.is_even(width) do
    # Subsampling by 2 in horizontal dimension
    # Y = width * height
    # V = U = (width / 2) * height
    {:ok, width * height * 2}
  end

  def frame_size(format, width, height) when format in [:I444, :RGB, :BGR] do
    # No subsampling
    {:ok, width * height * 3}
  end

  def frame_size(format, width, height) when format in [:AYUV, :RGBA, :BGRA] do
    # No subsampling and added alpha channel
    {:ok, width * height * 4}
  end

  def frame_size(format, width, height)
      when format in [:I420_10LE, :I420_10BE] and Integer.is_even(width) and
             Integer.is_even(height) do
    # Subsampling by 2 in both dimensions
    # Each pixel requires 2 bytes.
    # Y = 2 * width * height
    # V = U = 2 * (width / 2) * (height / 2)
    {:ok, 3 * width * height}
  end

  def frame_size(format, width, height)
      when format in [:I422_10LE, :I422_10BE] and Integer.is_even(width) do
    # Subsampling by 2 in horizontal dimension
    # Each pixel requires 2 bytes.
    # Y = 2 * width * height
    # V = U = 2 * (width / 2) * height
    {:ok, 4 * width * height}
  end

  def frame_size(format, width, height) when format in [:I444_10LE, :I444_10BE] do
    # No subsampling
    # Each pixel requires 2 bytes.
    {:ok, 6 * width * height}
  end

  def frame_size(format, _width, _height) when format in @supported_pixel_formats do
    {:error, :invalid_dimensions}
  end

  def frame_size(_format, _width, _height) do
    {:error, :invalid_pixel_format}
  end

  @doc """
  Converts raw video frame to `Vix.Vips.Image.t/0` struct.

  Calls `Vix.Vips.Image.new_from_binary/5` internally.
  """
  @spec payload_to_image(binary(), t()) :: {:ok, Vix.Vips.Image.t()} | {:error, term()}
  def payload_to_image(payload, %__MODULE__{} = raw_video) do
    with :RGB <- raw_video.pixel_format do
      Vix.Vips.Image.new_from_binary(
        payload,
        raw_video.width,
        raw_video.height,
        3,
        :VIPS_FORMAT_UCHAR
      )
    else
      other_format ->
        {:error, {:pixel_format_different_than_RGB, other_format}}
    end
  end

  @doc """
  Converts `Vix.Vips.Image.t/0` struct to raw video frame payload.

  Calls `Vix.Vips.Image.write_to_binary/1` internally.
  """
  @spec image_to_payload(Vix.Vips.Image.t()) :: {:ok, binary()} | {:error, term()}
  def image_to_payload(image) do
    image
    |> Image.flatten!()
    |> Image.to_colorspace!(:srgb)
    |> Vix.Vips.Image.write_to_binary()
  end
end

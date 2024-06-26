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
          :I420 | :I422 | :I444 | :RGB | :BGRA | :RGBA | :NV12 | :NV21 | :YV12 | :AYUV | :YUY2

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
    :BGRA,
    :RGBA,
    :NV12,
    :NV21,
    :YV12,
    :AYUV,
    :YUY2
  ]

  @doc """
  Simple wrapper over `frame_size/3`. Returns the size of raw video frame
  in bytes for the given caps.
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

  def frame_size(format, width, height) when format in [:I444, :RGB] do
    # No subsampling
    {:ok, width * height * 3}
  end

  def frame_size(format, width, height) when format in [:AYUV, :RGBA, :BGRA] do
    # No subsampling and added alpha channel
    {:ok, width * height * 4}
  end

  def frame_size(format, _width, _height) when format in @supported_pixel_formats do
    {:error, :invalid_dimensions}
  end

  def frame_size(_format, _width, _height) do
    {:error, :invalid_pixel_format}
  end
end

defmodule Membrane.Caps.Video.Raw do
  @moduledoc """
  This module provides caps struct for raw video frames.
  """

  @typedoc """
  Width of single frame in pixels.
  """
  @type width_t :: pos_integer()

  @typedoc """
  Height of single frame in pixels.
  """
  @type height_t :: pos_integer()

  @typedoc """
  Number of frames per second. To avoid using floating point numbers,
  it is described by 2 integers number of frames per timeframe in seconds.

  For example, NTSC's framerate of ~29.97 fps is represented by `{30_000, 1001}`
  """
  @type framerate_t :: {frames :: non_neg_integer, seconds :: pos_integer}

  @typedoc """
  Format used to encode color of each pixel in each video frame.
  """
  @type format_t :: :I420 | :I422 | :I444 | :RGB | :BGRA | :RGBA | :NV12 | :NV21 | :YV12 | :AYUV

  @typedoc """
  Determines, whether buffers are aligned i.e. each buffer contains one frame.
  """
  @type aligned_t :: boolean()

  @type t :: %__MODULE__{
          width: width_t(),
          height: height_t(),
          framerate: framerate_t(),
          format: format_t(),
          aligned: aligned_t()
        }

  @enforce_keys [:width, :height, :framerate, :format, :aligned]
  defstruct [:width, :height, :framerate, :format, :aligned]
end

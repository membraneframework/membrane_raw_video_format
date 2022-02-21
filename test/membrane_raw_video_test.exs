defmodule Membrane.RawVideo.Test do
  use ExUnit.Case, async: true
  @module Membrane.RawVideo

  defp format_struct(format, width, height) do
    %@module{
      pixel_format: format,
      width: width,
      height: height,
      framerate: {30, 1},
      aligned: true
    }
  end

  test "frame_size for :I420 format" do
    format = :I420
    assert @module.frame_size(format, 10, 20) == {:ok, 300}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:error, :invalid_dims}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 300}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:error, :invalid_dims}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:error, :invalid_dims}
  end

  test "frame_size for :I422 format" do
    format = :I422
    assert @module.frame_size(format, 10, 20) == {:ok, 400}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:ok, 380}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 400}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:error, :invalid_dims}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:ok, 380}
  end

  test "frame_size for :I444 format" do
    format = :I444
    assert @module.frame_size(format, 10, 20) == {:ok, 600}
    assert @module.frame_size(format, 9, 20) == {:ok, 540}
    assert @module.frame_size(format, 10, 19) == {:ok, 570}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 600}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:ok, 540}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:ok, 570}
  end

  test "frame_size for :RGB format" do
    format = :RGB
    assert @module.frame_size(format, 10, 20) == {:ok, 600}
    assert @module.frame_size(format, 9, 20) == {:ok, 540}
    assert @module.frame_size(format, 10, 19) == {:ok, 570}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 600}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:ok, 540}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:ok, 570}
  end

  test "frame_size for :BGRA format" do
    format = :BGRA
    assert @module.frame_size(format, 10, 20) == {:ok, 800}
    assert @module.frame_size(format, 9, 20) == {:ok, 720}
    assert @module.frame_size(format, 10, 19) == {:ok, 760}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 800}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:ok, 720}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:ok, 760}
  end

  test "frame_size for :RGBA format" do
    format = :RGBA
    assert @module.frame_size(format, 10, 20) == {:ok, 800}
    assert @module.frame_size(format, 9, 20) == {:ok, 720}
    assert @module.frame_size(format, 10, 19) == {:ok, 760}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 800}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:ok, 720}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:ok, 760}
  end

  test "frame_size for :NV12 format" do
    format = :NV12
    assert @module.frame_size(format, 10, 20) == {:ok, 300}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:error, :invalid_dims}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 300}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:error, :invalid_dims}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:error, :invalid_dims}
  end

  test "frame_size for :NV21 format" do
    format = :NV21
    assert @module.frame_size(format, 10, 20) == {:ok, 300}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:error, :invalid_dims}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 300}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:error, :invalid_dims}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:error, :invalid_dims}
  end

  test "frame_size for :YV12 format" do
    format = :YV12
    assert @module.frame_size(format, 10, 20) == {:ok, 300}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:error, :invalid_dims}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 300}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:error, :invalid_dims}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:error, :invalid_dims}
  end

  test "frame_size for :AYUV format" do
    format = :AYUV
    assert @module.frame_size(format, 10, 20) == {:ok, 800}
    assert @module.frame_size(format, 9, 20) == {:ok, 720}
    assert @module.frame_size(format, 10, 19) == {:ok, 760}

    assert @module.frame_size(format_struct(format, 10, 20)) == {:ok, 800}
    assert @module.frame_size(format_struct(format, 9, 20)) == {:ok, 720}
    assert @module.frame_size(format_struct(format, 10, 19)) == {:ok, 760}
  end

  test "frame_size error on unknown pixel format" do
    assert @module.frame_size(:yuv_240p, 10, 20) == {:error, :invalid_pixel_format}
  end
end

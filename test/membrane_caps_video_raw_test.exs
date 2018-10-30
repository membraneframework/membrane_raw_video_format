defmodule Membrane.Caps.Membrane.Caps.Video.Raw.Test do
  use ExUnit.Case, async: true
  @module Membrane.Caps.Video.Raw

  test "frame_size for :I420 format" do
    format = :I420
    assert @module.frame_size(format, 10, 20) == {:ok, 300}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:error, :invalid_dims}
  end

  test "frame_size for :I422 format" do
    format = :I422
    assert @module.frame_size(format, 10, 20) == {:ok, 400}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:ok, 380}
  end

  test "frame_size for :I444 format" do
    format = :I444
    assert @module.frame_size(format, 10, 20) == {:ok, 600}
    assert @module.frame_size(format, 9, 20) == {:ok, 540}
    assert @module.frame_size(format, 10, 19) == {:ok, 570}
  end

  test "frame_size for :RGB format" do
    format = :RGB
    assert @module.frame_size(format, 10, 20) == {:ok, 600}
    assert @module.frame_size(format, 9, 20) == {:ok, 540}
    assert @module.frame_size(format, 10, 19) == {:ok, 570}
  end

  test "frame_size for :BGRA format" do
    format = :BGRA
    assert @module.frame_size(format, 10, 20) == {:ok, 800}
    assert @module.frame_size(format, 9, 20) == {:ok, 720}
    assert @module.frame_size(format, 10, 19) == {:ok, 760}
  end

  test "frame_size for :RGBA format" do
    format = :RGBA
    assert @module.frame_size(format, 10, 20) == {:ok, 800}
    assert @module.frame_size(format, 9, 20) == {:ok, 720}
    assert @module.frame_size(format, 10, 19) == {:ok, 760}
  end

  test "frame_size for :NV12 format" do
    format = :NV12
    assert @module.frame_size(format, 10, 20) == {:ok, 300}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:error, :invalid_dims}
  end

  test "frame_size for :NV21 format" do
    format = :NV21
    assert @module.frame_size(format, 10, 20) == {:ok, 300}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:error, :invalid_dims}
  end

  test "frame_size for :YV12 format" do
    format = :YV12
    assert @module.frame_size(format, 10, 20) == {:ok, 300}
    assert @module.frame_size(format, 9, 20) == {:error, :invalid_dims}
    assert @module.frame_size(format, 10, 19) == {:error, :invalid_dims}
  end

  test "frame_size for :AYUV format" do
    format = :AYUV
    assert @module.frame_size(format, 10, 20) == {:ok, 800}
    assert @module.frame_size(format, 9, 20) == {:ok, 720}
    assert @module.frame_size(format, 10, 19) == {:ok, 760}
  end
end

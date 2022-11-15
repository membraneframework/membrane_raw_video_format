defmodule Membrane.Native.RawVideoTest do
  use ExUnit.Case

  alias Membrane.Native.RawVideo, as: NativeRawVideo
  alias Membrane.RawVideo

  setup do
    raw_video = %Membrane.RawVideo{
      width: 1920,
      height: 1080,
      pixel_format: :I420,
      framerate: {30, 1},
      aligned: true
    }

    exp_native_raw_video = %NativeRawVideo{
      width: 1920,
      height: 1080,
      pixel_format: :I420,
      framerate_num: 30,
      framerate_den: 1,
      aligned: true
    }

    %{raw_video: raw_video, exp_native_raw_video: exp_native_raw_video}
  end

  describe "From Membrane.RawVideo to Native conversion" do
    test "using Membrane.RawVideo module", %{
      raw_video: raw_video,
      exp_native_raw_video: exp_native_raw_video
    } do
      assert RawVideo.to_native_raw_video(raw_video) == exp_native_raw_video
      assert RawVideo.from_native_raw_video(exp_native_raw_video) == raw_video
    end

    test "using Membrane.Native.RawVideo module", %{
      raw_video: raw_video,
      exp_native_raw_video: exp_native_raw_video
    } do
      assert NativeRawVideo.from_membrane_raw_video(raw_video) == exp_native_raw_video
      assert NativeRawVideo.to_membrane_raw_video(exp_native_raw_video) == raw_video
    end
  end
end

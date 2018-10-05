defmodule Membrane.Caps.Video.Raw.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/membraneframework/membrane-caps-video-raw"

  def project do
    [
      app: :membrane_caps_video_raw,
      version: @version,
      elixir: "~> 1.7",
      description: "Membrane Multimedia Framework (Raw video format definition)",
      package: package(),
      name: "Membrane Caps: Video Raw",
      source_url: @github_url,
      docs: docs(),
      deps: deps()
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membraneframework.org"
      }
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end

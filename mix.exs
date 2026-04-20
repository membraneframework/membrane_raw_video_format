defmodule Membrane.RawVideo.Mixfile do
  use Mix.Project

  @version "0.4.3"
  @github_url "https://github.com/membraneframework/membrane_raw_video_format"

  def project do
    [
      app: :membrane_raw_video_format,
      version: @version,
      elixir: "~> 1.12",
      description:
        "Definition of raw (uncompressed) video format for Membrane Multimedia Framework",
      package: package(),
      dialyzer: dialyzer(),
      name: "Membrane: Raw video format",
      source_url: @github_url,
      docs: docs(),
      deps: deps()
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", LICENSE: [title: "License"]],
      formatters: ["html"],
      source_ref: "v#{@version}"
    ]
  end

  defp dialyzer() do
    opts = [
      flags: [:error_handling],
      plt_add_apps: [:mix, :syntax_tools]
    ]

    if System.get_env("CI") == "true" do
      File.mkdir_p!(Path.join([__DIR__, "priv", "plts"]))
      [plt_local_path: "priv/plts", plt_core_path: "priv/plts"] ++ opts
    else
      opts
    end
  end

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membrane.stream/"
      }
    ]
  end

  defp deps do
    [
      {:image, ">= 0.54.0", optional: true},
      {:plug, "~> 1.15", optional: true},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: :dev, runtime: false}
    ]
  end
end

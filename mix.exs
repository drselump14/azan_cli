defmodule AzanCli.MixProject do
  use Mix.Project

  def project do
    [
      app: :azan_cli,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  def releases do
    [
      azan_cli: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            # macos: [os: :darwin, cpu: :x86_64],
            macos_arm: [os: :darwin, cpu: :aarch64]
            # linux: [os: :linux, cpu: :x86_64],
            # windows: [os: :windows, cpu: :x86_64]
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AzanCli, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:azan_ex, "~> 0.2.0"},
      {:burrito, "~> 1.2"},
      {:timex, "~> 3.7"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

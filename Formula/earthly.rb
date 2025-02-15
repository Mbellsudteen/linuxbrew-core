class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.6.tar.gz"
  sha256 "666ce1f3235aab343e09a9d977828181453048a8ac589fea888af4a64a768e82"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ce971c828e454660b53f94c2f81bd08f83c57bb584be909af4b6e89c8ae107b"
    sha256 cellar: :any_skip_relocation, big_sur:       "38810651d404977929a24c6c492df87f67ce61d6163ad2227d915e37983b1b92"
    sha256 cellar: :any_skip_relocation, catalina:      "eeeed6077f46d5d8a6cf4e00ea21ee67fa6a17adb10e9d12213d581a9db8b8bc"
    sha256 cellar: :any_skip_relocation, mojave:        "62a4985eb4b8704977d88d9a569ee8005e4cd26559901c756f9d0e0266d3e8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4aca1d8b40187b26d86d9d2d1227fe00de5625f560b423f055a1cef1afe171"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=42b5954b13f50dcf9683905012ec26dfc222b500 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "./cmd/earthly/main.go"

    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earthly").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earthly").write zsh_output
  end

  test do
    (testpath/"build.earthly").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end

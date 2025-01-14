class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.107.0",
      revision: "f6a9675459892bc9342cb7d07a6cd89a35387b61"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bc98a9216a0e95c5dbe3be6e32caa051ea30013d89c47f0d0f4ecf0b0c034a2"
    sha256 cellar: :any,                 big_sur:       "4d07c733c5bc6233ff17224c5a04999abe8e8f61b1502f3b40b3fba45bf44069"
    sha256 cellar: :any,                 catalina:      "5711fcf9a6a634ac3fdd5c1345f99500b65b8defb9edb290a3688da3366f1278"
    sha256 cellar: :any,                 mojave:        "2f29a8cc4d0a4362ce7d1b760304bad9ce0b5372d9ca4c14bbae00b12b7842c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3eb019dd2760888f84e8903172b85362b8b1c34e46c04b60d02d1547a4fd2f"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "ragel" => :build
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end

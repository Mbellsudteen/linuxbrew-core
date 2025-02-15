class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.1.7.tar.gz"
  sha256 "f76b82951c3ecd0a34e2e7927a5163c8471bec675146f87d7a87df02d66c2a4d"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15b565e94faaca48f9b77f91fdbfd09356e1fe1d4ecc994bf4771b69775f6970"
    sha256 cellar: :any_skip_relocation, big_sur:       "9776a8cfa2ce861028e4b359a4e1ece0efed04c3645388dc584398f031740c49"
    sha256 cellar: :any_skip_relocation, catalina:      "709193f4a31a5e065c922d4873e3dd89087f6eb23f2ac06e1c2a1ee91cc44131"
    sha256 cellar: :any_skip_relocation, mojave:        "5d853d4361569132df6f4f10ccfc124cda557b8ff4fa061743430f844268dcdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f660b1f32d7ccf2c0a634af8c3163fad4b2cefbcdeb20f7df3431babe638996f"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end

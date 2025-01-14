class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.13.7.tar.gz"
  sha256 "1b5774b0ce2806176f338efc7eb886e338b87d705cbd66978c2535e78faf548d"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84fbe4455dabeeedad27400ba961e34aca8cb856a229fb151be34e065d734a02"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2fc3bb1964e1f8ca05187479a3ae1cdc349159a74383c607f1678d88775a936"
    sha256 cellar: :any_skip_relocation, catalina:      "f5a7ba83fa1c59bfb998cc92b98364a05a9aa1d0c0c50c9e277c397f4afc6f7b"
    sha256 cellar: :any_skip_relocation, mojave:        "6890855c13f50132f22bb684b6921ce7d1ab8bf6154c5f2374d32e797fc37cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54b289aa5e1d9a6cdcbca0c46cb4d1ebb39dc1d713fbfd4e04759ed1cc52a2a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end

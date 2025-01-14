require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.10.6.tgz"
  sha256 "3e4ea80d6e0289a8accee2d886c456a793867fa05fc589541dfebaab189cfc8f"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "781ea676ccc947b50646e53e8a29051d1019d142bbf6c5415332a31f62bc74e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc99ea50a494ec5e58dc8ba67907e277c22baf8332c697c9ca227bfcaf0001db"
    sha256 cellar: :any_skip_relocation, catalina:      "30be90ea8f6cdc44d1ee8c48b39f65721351ca27dda6008b1a2576496bfca820"
    sha256 cellar: :any_skip_relocation, mojave:        "0c1d4cc79e614d4a553eb152adaf8851dd55da9b09950dc72e58f775f3014fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e2d88b0acd0db003b6e48a11b5d8b7ae0d38355c34251d7f5b7887ef0729d2"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end

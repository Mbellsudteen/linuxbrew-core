class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.0.tar.gz"
  sha256 "9f581c1cb13d87e9591bff6983e10f286b6ca248e7cd82cb74c5df1d732d3364"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b96da4ca59ba676a390e62ca0ca5680f3dc2a52d6e2759de19820adafa5f8507"
    sha256 cellar: :any_skip_relocation, big_sur:       "783a8c3add56b2da1ace0a143a6a1aa13129bfa5380efd01f8d9ef05c93debea"
    sha256 cellar: :any_skip_relocation, catalina:      "492e1d33d845c0fe6d6544c0a22d9af51119ecd7bc04663f00ce76b05854dc77"
    sha256 cellar: :any_skip_relocation, mojave:        "53678d4243143d52b4ab8edd19802f3355a6144042e8ac8d0252e5d1bc10939e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd84b74fc742aef7124400800d3b95d5def4f4dab1cbf4aa078df9eec3882ec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end

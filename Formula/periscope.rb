class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.2.0",
      revision: "d672bf60f4b59c1f54fa3c26aef75d0593615c40"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8cfadad385f69d292c7fa21e74962839f802c4f715fdf90c3bd2a8b588c0ce91"
    sha256 cellar: :any_skip_relocation, big_sur:       "9824c9c61ed092523c30284612f1ddfa9c0725cd6c13c854340f47a4fa0ff6d3"
    sha256 cellar: :any_skip_relocation, catalina:      "9b11b76bc3d4a06f735e88293a5c2263dbea9c4ed6d023bd6b1d88c6ba73a5f6"
    sha256 cellar: :any_skip_relocation, mojave:        "b86dff9739ead37c41f5a40f6641c1795d515517d99d134ad900bf47b383b453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69942f9b759857d40dcfa46e555c849f03490e06226fa638e1d9acd0596b9aaa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
      "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head}",
      "-trimpath", "./cmd/psc"

    bin.install "psc"

    # install bash completion
    output = Utils.safe_popen_read("#{bin}/psc", "completion", "bash")
    (bash_completion/"psc").write output

    # install zsh completion
    output = Utils.safe_popen_read("#{bin}/psc", "completion", "zsh")
    (zsh_completion/"_psc").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psc version")

    # setup
    (testpath/"a").write("dupe")
    (testpath/"b").write("dupe")
    (testpath/"c").write("unique")

    # scan + summary is correct
    shell_output "#{bin}/psc scan 2>/dev/null"
    summary = shell_output("#{bin}/psc summary").strip.split("\n").map { |l| l.strip.split }
    assert_equal [["tracked", "2"], ["unique", "1"], ["duplicate", "1"], ["overhead", "4", "B"]], summary

    # rm allows deleting dupes but not uniques
    shell_output "#{bin}/psc rm #{testpath/"a"}"
    assert_not_predicate (testpath/"a"), :exist?
    # now b is unique
    shell_output "#{bin}/psc rm #{testpath/"b"} 2>/dev/null", 1
    assert_predicate (testpath/"b"), :exist?
    shell_output "#{bin}/psc rm #{testpath/"c"} 2>/dev/null", 1
    assert_predicate (testpath/"c"), :exist?

    # cleanup
    shell_output("#{bin}/psc finish")
  end
end

class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/21/9a/5ac44a0e4f8f9444a4ce9aff9ebc2c4e14da5224432bb489154da9eddfa0/pre_commit-2.11.0.tar.gz"
  sha256 "06f8cb95e29e56788fb5dc98d7ca7a714969dc96633e1ba654ccd5953b64c195"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "51b95a42c809305cecab47eff7f8164d5b0391f67f36df8f00844c361bf020f6"
    sha256 cellar: :any,                 big_sur:       "cab6ac0186b3c6c41b8a7695364c3173b89a3cc1b1a6c805edb87f28a18fb1e6"
    sha256 cellar: :any,                 catalina:      "3b73bae0f1b262f2d62f5c3d68c8ada7337aef080ea8becea27b148868ab4293"
    sha256 cellar: :any,                 mojave:        "978f99eaa6eb34a488708f9bf6f418800e8b1f7837a0c3a91df41a16ee4ce8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22307b533dd5097dc98597786318b82f1f82efbc43051b6d333b2bbac7256168"
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/63/75/c80804e4a5eccc9acf767faf4591bb7ab289485ba236dfee542467dc7c9b/cfgv-3.2.0.tar.gz"
    sha256 "cf22deb93d4bcf92f345a5c3cd39d3d41d6340adc60c78bbbd6588c384fda6a1"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/ad/8d/f2390cfe86e7b839bb5228f3b57d7476a64ed6fba751e67b145234786d57/identify-2.1.0.tar.gz"
    sha256 "2179e7359471ab55729f201b3fdf7dc2778e221f868410fedcb0987b791ba552"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/2f/15/d1eb0d2664e57da61622a815efe7a88db68c7a593fb86bd7cc629fc31c76/nodeenv-1.5.0.tar.gz"
    sha256 "ab45090ae383b716c4ef89e690c41ff8c2b257b85b309f01f3654df3d084bd7c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/79/64/203241c2e2b5abfd5edca4e28242c21bf8a9e84490873e4a8a155a9658fc/virtualenv-20.4.2.tar.gz"
    sha256 "147b43894e51dd6bba882cf9c282447f780e2251cd35172403745fc381a0a80d"
  end

  def install
    # Point hook shebang to virtualenv Python.
    # The global one also works - but may be keg-only.
    # A full path can also move around if we use versioned formulae.
    # Git hooks should only have to be installed once and never need changing.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'#!/usr/bin/env {py}'",
              "'#!#{opt_libexec}/bin/python3'"

    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "'INSTALL_PYTHON': sys.executable",
              "'INSTALL_PYTHON': '#{opt_libexec}/bin/python3'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    bin_python_path = Pathname(libexec/"bin")
    lib_python_path = Pathname(libexec/"lib/python#{xy}")
    [lib_python_path, bin_python_path].each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end

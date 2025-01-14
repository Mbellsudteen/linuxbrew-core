class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.20.0-Source.tar.gz"
  sha256 "207a3d7966e75d85920569b55a19824673e8cd0b50db4c4dac2d3d52eacd7985"
  license "Apache-2.0"
  revision OS.mac? ? 1 : 2

  livecheck do
    url "https://software.ecmwf.int/wiki/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "05c40d658fc48a091bbcf0c42f3b4a60e809d2c1f03e224a1496391d25cbfb70"
    sha256 big_sur:       "8cb7f7bddf32ae37ef9fbb33ca784408472fe91408f5ee4a6368ce7ad39e90f4"
    sha256 catalina:      "f0a852163220dea5ddc86937eb58a3369eaedf99f9103855fade7dd682e116bd"
    sha256 mojave:        "5337b703af5451832edf3b79c08b2898c7ed4b305b849b02fbf2762ab043719d"
    sha256 x86_64_linux:  "653698b8d6147aa972806de80cb98c9f44b520108946b7da21893e3f1f849c35"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    # Fix for GCC 10, remove with next version
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=957159
    ENV.prepend "FFLAGS", "-fallow-argument-mismatch"

    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
      system "make", "install"
    end

    # Avoid references to Homebrew shims directory
    os = OS.mac? ? "mac" : "linux"
    cc = OS.mac? ? "clang" : "gcc-5"
    path = HOMEBREW_LIBRARY/"Homebrew/shims/#{os}/super/#{cc}"
    inreplace include/"eccodes_ecbuild_config.h", path, "/usr/bin/#{cc}"
    inreplace lib/"pkgconfig/eccodes.pc", path, "/usr/bin/#{cc}"
    inreplace lib/"pkgconfig/eccodes_f90.pc", path, "/usr/bin/#{cc}"
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end

class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.4/libadwaita-1.4.2.tar.xz"
  sha256 "33fa16754e7370c841767298b3ff5f23003ee1d2515cc2ff255e65ef3d4e8713"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e1559b512441394ecf464a0f4d1515beeae56f3387e6b54e7de3c750fce6b52e"
    sha256 arm64_ventura:  "4904eb43384a6d1d28a7d607b17f5c098a2571053d8db25933543f3eac506313"
    sha256 arm64_monterey: "bad6be52748f7c2cde4c72743c18b0ba6be2194841b4a838ae2d88a322a5b3dc"
    sha256 sonoma:         "cce489a72a26cad4453c9c0af229837d102869b12b7cfc0689172e273fe327ca"
    sha256 ventura:        "c344d29e6c7fddef021791c0cb1ad4e34bc3c7d1ef6560a2e23d4d76eaa53b2e"
    sha256 monterey:       "0ef04a47bd610debc1f328678210287d9ef0413ba4f1ba89b9db2f800288217b"
    sha256 x86_64_linux:   "11370a2a350ed986b03ce0daa1fa6558826223bd642d6594f6a75c10a344693d"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "appstream"
  depends_on "gtk4"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_DEFAULT_FLAGS);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end

class GlibcHeaders < Formula
  desc "GNU C Library development package"
  homepage "https://www.gnu.org/software/libc"
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.40.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/glibc/glibc-2.40.tar.gz"
  sha256 "2abc038f5022949cb67e996c3cae0e7764f99b009f0b9b7fd954dfc6577b599e"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  keg_only :versioned_formula

  patch do
    url "https://raw.githubusercontent.com/dkruces/formula-patches/48607d3c69db7b21ad27d4132af86102a26b36d5/glibc-headers/0001-headers-prepare-minimal-headers-for-macos.patch"
    sha256 "5e4fda5b22fd3a7e19b61f7921ca501473bc8265c80085ed995cd668c2703e83"
  end

  def install
    include.install "string/byteswap.h" => "byteswap.h"
    include.install "elf/elf.h" => "elf.h"
    include.install "string/endian.h" => "endian.h"
    include.install "include/features.h" => "features.h"
    include.install "include/stdc-predef.h" => "stdc-predef.h"

    (include/"bits").mkpath
    (include/"bits").install "bits/byteswap.h"
    (include/"bits").install "bits/uintn-identity.h"

    # Generate the pkg-config file
    (lib/"pkgconfig").mkpath
    (lib/"pkgconfig/libc-dev.pc").write <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      includedir=${prefix}/include
      libdir=${prefix}/lib

      Name: libc-dev
      Description: glibc headers for Linux development
      Version: glibc-2.40
      Cflags: -I${includedir}
      Libs: -L${libdir}
    EOS
  end

  test do
    system "test", "-f", "#{include}/byteswap.h"
    system "test", "-f", "#{include}/elf.h"
    system "test", "-f", "#{include}/endian.h"
    system "test", "-f", "#{include}/features.h"
    system "test", "-f", "#{include}/stdc-predef.h"
    system "test", "-f", "#{include}/bits/byteswap.h"
    system "test", "-f", "#{include}/bits/uintn-identity.h"
  end
end

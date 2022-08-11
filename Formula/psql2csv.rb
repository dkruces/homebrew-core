class Psql2csv < Formula
  desc "Run a query in psql and output the result as CSV"
  homepage "https://github.com/fphilipe/psql2csv"
  url "https://github.com/fphilipe/psql2csv/archive/v0.12.tar.gz"
  sha256 "bd99442ee5b6892589986cb93f928ec9e823d17d06f10c8e74e7522bf021ca28"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c33e20a01b09f6161318136ae5e4529cea292fd1783ce8b81bdf13a58c5453b"
  end

  depends_on "libpq"

  def install
    bin.install "psql2csv"
  end

  test do
    expected = "COPY (SELECT 1) TO STDOUT WITH (FORMAT csv, ENCODING 'UTF8', HEADER true)"
    output = shell_output(%Q(#{bin}/psql2csv --dry-run "SELECT 1")).strip
    assert_equal expected, output
  end
end

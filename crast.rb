class Crast < Formula
  desc "Command-line, directory based todo list app"
  homepage "https://github.com/safe-k/crast"
  url "https://github.com/safe-k/crast/archive/v1.0.0.tar.gz"
  sha256 "896b1957dd38dae52f1a5ce8b62f8e2a7b27d9ae43d74733fddfa447dc021cb9"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "crast", "./cmd"
    bin.install "crast"
  end

  test do
    system "#{bin}/crast", "--help"
  end
end

{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "rtw8852cu";
  version = "unstable-2024-05-10";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852cu-20240510";
    rev = "c0a24a91a4e3c60aeb0e5fa6d5aad853d1cdf4e2";
    sha256 = "sha256-Nj+qRa0C2OAkJR8TtqrvmqDLOLp6GmWwF5/9OhJMD0g=";
  };

  nativeBuildInputs = [ bc nukeReferences ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless
    cp 8852cu.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/
  '';

  postFixup = ''
    nuke-refs $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/8852cu.ko
  '';

  meta = with lib; {
    description = "Realtek RTL8852CU USB WiFi driver";
    homepage = "https://github.com/morrownr/rtl8852cu-20240510";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}

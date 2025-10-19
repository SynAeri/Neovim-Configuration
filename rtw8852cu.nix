{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "rtw8852cu";
  version = "1.19.2.1-20240510";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852cu-20240510";
    rev = "f9d5fee3f7db06df75dbad06fdc4fc057d3fd990";  # Latest commit as of Dec 2024
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # Will be updated on first build
  };

  nativeBuildInputs = [ bc nukeReferences ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "USER_MODULE_NAME=8852cu"
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
    description = "Realtek RTL8852CU/RTL8832CU USB WiFi driver";
    homepage = "https://github.com/morrownr/rtl8852cu-20240510";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}

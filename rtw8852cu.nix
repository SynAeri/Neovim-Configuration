{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "rtw8852cu";
  version = "unstable-2024-12-08";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852cu-20240510";
    rev = "main";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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

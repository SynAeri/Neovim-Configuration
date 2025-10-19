{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation {
  pname = "rtw8852cu";
  version = "2024-12-08";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852cu-20240510";
    rev = "main";
    sha256 = "sha256-yp5e2ijkqKji+dJ+XPMJJPhkjh5NYUiFEncQc4HdNEA=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ bc ];
  
  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$(pwd) \
      modules
  '';

  installPhase = ''
    install -D -m644 8852cu.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/8852cu.ko
  '';

  meta = {
    description = "Realtek RTL8852CU USB WiFi driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}

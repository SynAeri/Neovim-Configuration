{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "rtw8852cu";
  version = "unstable-2024-12-08";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852cu-20240510";
    rev = "main";
    sha256 = "sha256-yp5e2ijkqKji+dJ+XPMJJPhkjh5NYUiFEncQc4HdNEA=";
  };

  nativeBuildInputs = [ bc nukeReferences ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" "format" ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/"
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ] ++ kernel.makeFlags;

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless
    cp 8852cu.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Realtek RTL8852CU/RTL8832CU USB WiFi driver";
    homepage = "https://github.com/morrownr/rtl8852cu-20240510";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.10" || kernel.kernelAtLeast "6.18";
  };
}

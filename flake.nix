{
  description = "Flutter Inspection App";

  inputs = {
    # nixpkgs.url = "github:HannesGitH/nixpkgs/hannes_custom";
    nixpkgs.url = "github:nixos/nixpkgs/cf8cc1201be8bc71b7cbbbdaf349b22f4f99c7ae";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkg-opts = {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };
        pkgs = import nixpkgs { inherit (pkg-opts) system config;};
        pkgs-stable = import nixpkgs-stable { inherit (pkg-opts) system config; };
      in rec {

        deps = with pkgs; [
          flutter
          git
        ];

        android-data = {
          abiVersion = "x86_64";
          platformVersion = "34";
        };

        android = pkgs-stable.androidenv.composeAndroidPackages {
          buildToolsVersions = [ "28.0.3" "30.0.3" ];
          platformVersions = [ "28" "33" "31" android-data.platformVersion ];
          abiVersions = [ "armeabi-v7a" "arm64-v8a" android-data.abiVersion ];
        };

        # android = pkgs.androidenv.androidPkgs_9_0;

        packages = {
          avd = pkgs-stable.androidenv.emulateApp {
            name = "run-test-emulatorem";
            platformVersion = android-data.platformVersion;
            abiVersion = android-data.abiVersion; # armeabi-v7a, mips, x86_64
            systemImageType = "google_apis_playstore";
            # deviceName = "test-emulator";
          };

        };

        defaultPackage = packages.avd;

        devShells = rec {
          apk = pkgs.mkShell rec {
            name = "apk";
            buildInputs = with pkgs; deps ++ [ jdk17 android.androidsdk packages.avd android-tools flutter ];
            ANDROID_SDK_ROOT = "${android.androidsdk}/libexec/android-sdk";
            shellHook = ''
              echo "hi"
              export ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
            '';
          };
          default = apk;
        };
      });
}

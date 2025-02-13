{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      supportSystems = [
        "aarch64-darwin" # 64-bit ARM macOS
        "aarch64-linux"  # 64-bit ARM Linux
        "x86_64-darwin"  # 64-bit x86 macOS
        "x86_64-linux"   # 64-bit x86 Linux
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportSystems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Ruby
              ruby
              # Native gem dependencies
              imagemagick
              libmysqlclient
              pkg-config
              # Node.js package manager
              yarn
              # Task runner
              go-task
              # AWS CLI
              awscli
              # AWS SSM Session Manager Plugin
              ssm-session-manager-plugin
              # AWS ECS tools
              ecsk
            ];
            shellHook = ''
              export DB_PASS="root"
              export TZ="Asia/Tokyo"
              export DB_HOST="127.0.0.1"
              export DB_PASS=root
              export REDIS_URL="127.0.0.1://redis:6379/0"
              export REDIS_HOST="127.0.0.1"
              export ES_HOST="127.0.0.1"
              export SELENIUM_HOST="127.0.0.1"
            '';
          };
        }
      );
    };
}

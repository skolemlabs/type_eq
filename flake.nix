{
  description = "Type equality proofs for OCaml 4+";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    let
      project = {
        name = "type_eq";
        version = "0.0.1";

        ocamlVersion = "ocamlPackages_4_08";
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        legacyPackages = nixpkgs.legacyPackages.${system};
        ocamlPackages = legacyPackages.ocaml-ng.${project.ocamlVersion};

        sources = {
          ocaml = nix-filter.lib {
            root = ./.;
            include = [
              ".ocamlformat"
              "dune-project"
              (nix-filter.lib.inDirectory "bin")
              (nix-filter.lib.inDirectory "lib")
              (nix-filter.lib.inDirectory "test")
            ];
          };

          nix = nix-filter.lib {
            root = ./.;
            include = [
              (nix-filter.lib.matchExt "nix")
            ];
          };
        };
      in

      {
        packages = {
          default = self.packages.${system}.${project.name};

          ${project.name} = ocamlPackages.buildDunePackage {
            pname = project.name;
            version = project.version;
            duneVersion = "3";
            src = sources.ocaml;

            buildInputs = [ ];

            strictDeps = true;

            preBuild = "dune build ${project.name}.opam";
          };
        };

        devShells = {
          default = legacyPackages.mkShell {
            packages = [
              legacyPackages.fswatch
              legacyPackages.ocamlformat
              ocamlPackages.ocaml-lsp
            ];

            inputsFrom = [
              self.packages.${system}.${project.name}
            ];
          };
        };
      });
}

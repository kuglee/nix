{ pkgs, ... }:

let
  tomlFormat = pkgs.formats.toml { };
in
{
  xdg.configFile."mago.toml".source = tomlFormat.generate "mago.toml" {
    formatter = {
      classlike-brace-style = "same-line";
      closure-brace-style = "same-line";
      function-brace-style = "same-line";
      inline-empty-classlike-braces = true;
      inline-empty-function-braces = true;
      inline-empty-method-braces = true;
      method-brace-style = "same-line";
      preserve-breaking-argument-list = false;
      preserve-breaking-array-like = false;
      preserve-breaking-attribute-list = false;
      preserve-breaking-condition-expression = false;
      preserve-breaking-conditional-expression = false;
      preserve-breaking-member-access-chain = false;
      preserve-breaking-parameter-list = false;
      print-width = 120;
      tab-width = 4;
      use-tabs = false;
      trailing-comma = false;
    };
  };
}


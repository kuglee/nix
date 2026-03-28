{ config, pkgs, ... }:

{
  home.file.".swiftformat".text = ''
--swift-version 6.1
--language-mode 6

# indent
--max-width 100
--indent 2

# blank lines
--enable blankLinesBetweenImports
--line-between-guards true

# extensionAccessControl
--extension-acl on-declarations

--disable opaqueGenericParameters
--disable unusedArguments
--disable unusedPrivateDeclarations
--disable consistentSwitchCaseSpacing
--disable wrapMultilineStatementBraces

# wrap
--enable wrapMultilineConditionalAssignment
--enable wrapMultilineFunctionChains
--wrap-arguments before-first
--wrap-collections before-first
--wrap-conditions after-first
--wrap-effects never
--wrap-parameters before-first
--wrap-return-type never
--wrap-type-aliases before-first
--complex-attributes prev-line
--computed-var-attributes prev-line
--func-attributes prev-line
--stored-var-attributes prev-line
--type-attributes prev-line
  '';
}

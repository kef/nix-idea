# NixIDEA - A Nix language plugin for IntelliJ IDEA

[![Build Status](https://travis-ci.org/NixOS/nix-idea.svg?branch=master)](https://travis-ci.org/NixOS/nix-idea)

<!-- Plugin description -->

This plugin has the goal of being generally useful when working with nixpkgs/NixOS/nixops, it aims
to provide the following:

* Syntax Highlighting
* Linting
* Profile management
* Suggestions for:
    * Attributes
    * Builtins
    * Filesystem paths
* Templates for common usage patterns

<!-- Plugin description end -->

## Install

### From JetBrains marketplace

The plugin can be found at the Jetbrains plugin repository as
[NixIDEA][marketplace].

* Goto **File > Settings > Plugins > Marketplace**
* Type **NixIDEA** into the search bar
* Click **Install**

### From ZIP file

You can also install the plugin from a ZIP file.

* Goto **File > Settings > Plugins**
* Click onto the **wheel icon** on the top
* Choose **Install Plugin from Disk**

You can find corresponding ZIP files [on GitHub][releases] or build them
yourself as described below.

## Build

### Build preparation

Follow the following steps before you build the project the first time.

* Clone the repository
* Ensure that you have a JDK for Java 11 or higher on your PATH
* Only on NixOS: Setup JetBrains Runtime (JBR) from `<nixpkgs>`
  ```sh
  nix-build '<nixpkgs>' -A jetbrains.jdk -o jbr
  ```

### Build execution

After you have completed the preparation, you can build the plugin by
running the `build` task in Gradle.

```sh
./gradlew build
```

You should then find the plugin in
`build/distributions/NixIDEA-<version>.zip`.


[marketplace]:
<https://plugins.jetbrains.com/plugin/8607>
"NixIDEA - Plugins | JetBrains"
[releases]:
<https://github.com/NixOS/nix-idea/releases>
"Releases · NixOS/nix-idea"

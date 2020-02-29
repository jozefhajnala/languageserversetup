# languageserversetup

> Setup and initualize R languageserver seamlessly and automatically with editors such as VS Code.

![Deploy-MSWin](https://github.com/jozefhajnala/languageserversetup/workflows/deploy_win/badge.svg)
![Deploy-MacOS](https://github.com/jozefhajnala/languageserversetup/workflows/deploy_macos/badge.svg)
![Deploy-CRAN](https://github.com/jozefhajnala/languageserversetup/workflows/deploy_debian_cran/badge.svg)
![Deploy-Dev](https://github.com/jozefhajnala/languageserversetup/workflows/deploy_debian_dev/badge.svg)
![Check-CRAN](https://github.com/jozefhajnala/languageserversetup/workflows/check_cran/badge.svg)


## Features

* Installs the languageserver and all of its dependencies to an independent library
* Adds code to .Rprofile to make startup seamless.
* Checks whether an R process is triggered as an instance of the languageserver and if so, initializes it using the independent library to prevent conflicts with other packages that users use
* The languageserver installation does not effect the packages users currently have installed

## Installation

You can install `languageserversetup` from GitHub using the remotes package. It has no, so no other packages are installed.

```r
remotes::install_github("jozefhajnala/languageserversetup")
```

## Usage

1. Install the `languageserver` and all it's dependencies into a separate independent library (Will ask for confirmation before taking action).

```
languageserversetup::languageserver_install()
```

2. Add code to .Rprofile to automatically instantiate languageserver if the process is an instance of the languageserver

```
languageserversetup::languageserver_add_to_rprofile()
```

3. Enjoy the cool functionality with VS Code or other editors.

## Removing the functionality

To remove the functionality, run (Will ask for confimation before taking action):

```
languageserversetup::languageserver_remove_from_rprofile()
```

If the above does not succeed, remove the `languageserersetup` related code from your `.Rprofile`.


## Customizing the behavior

### The location of the languageserver library

The default location for the library is `path.expand(file.path("~", "languageserver-library"))`. The simplest way to customize the location of the library is to use `options(langserver_library = "desired/path/to/library")` and place that option into the `.Rprofile`.

## Options

The default package behavior can be adjusted by the following options, ideally placed in the `.Rprofile` file before the call to `library(languageserversetup)`

* for troubleshooting purposes, use `options(langserver_quiet = FALSE)` to enable diagnostic messages
* to define a custom library location for the languageserver package and its dependencies, use `options(langserver_library = "desired/path/to/library")`


## How does it work

Please refer to `?languageserver_install

## License

AGPL-3

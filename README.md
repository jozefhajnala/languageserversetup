# languageserversetup

> Setup and initialize R language server seamlessly and automatically with editors such as VS Code across platforms.

![Deploy-MS-Win](https://github.com/jozefhajnala/languageserversetup/workflows/deploy_win/badge.svg)
![Deploy-MacOS](https://github.com/jozefhajnala/languageserversetup/workflows/deploy_macos/badge.svg)
![Deploy-CRAN](https://github.com/jozefhajnala/languageserversetup/workflows/deploy_debian_cran/badge.svg)
![Deploy-Dev](https://github.com/jozefhajnala/languageserversetup/workflows/deploy_debian_dev/badge.svg)
![Check-CRAN](https://github.com/jozefhajnala/languageserversetup/workflows/check_cran/badge.svg)
![Check-Solaris](https://github.com/jozefhajnala/languageserversetup/workflows/check_solaris/badge.svg)
[![License](https://img.shields.io/badge/license-AGPL%20(3.0)-success.svg?style=flat&labelColor=rgb(40,45,51))](http://www.gnu.org/licenses/agpl-3.0.html) 


## Features

* Installs the [languageserver](https://github.com/REditorSupport/languageserver) package and all of its dependencies into a separate, independent library
* Adds code to `.Rprofile` to make startup of the language server seamless when appropriate
* Checks whether an R process is triggered as an instance of the languageserver and if so uses the independent library to prevent conflicts with other packages that the user uses
* The languageserver installation does not affect the packages users currently have installed


## Installation


You can install `languageserversetup` from CRAN. It has no dependencies, so no other packages are installed:

```r
install.packages("languageserversetup")
```

You can also install the latest development version from the master branch on GitHub using the remotes package:

```r
remotes::install_github("jozefhajnala/languageserversetup")
```


## Usage

1. Install the `languageserver` package and all it's dependencies into a separate independent library (Will ask for confirmation before taking action)

```r
languageserversetup::languageserver_install()
```

2. Add code to `.Rprofile` to automatically instantiate languageserver if the process is an instance of the languageserver, otherwise, the R session will run as usual with library paths unaffected

```r
languageserversetup::languageserver_add_to_rprofile()
```

3. Enjoy the cool functionality with VS Code or other editors


## In action with VS Code

### Install languageserversetup and use `languageserver_install()`

![Installing the language server](https://user-images.githubusercontent.com/23148397/75627074-5888b900-5bcd-11ea-8abf-8008ef0719df.gif)

### Initialize the functionality with `languageserver_add_to_rprofile()`

![Adding the language server to startup](https://user-images.githubusercontent.com/23148397/75627078-5aeb1300-5bcd-11ea-9752-448f842ac29d.gif)

All done, enjoy the awesomeness!


## Platform support

Currently, the functionality is tested on 64bit versions of MS Windows 7, 10, Ubuntu 18.10 and MacOS El Capitan. Automated deployments and tests run via GitHub actions on macos-elcapitan-release, windows-x86_64-devel, ubuntu-gcc-release and fedora-clang-devel.

All PR and issues related to platform support are most welcome! 


## Removing the functionality

To remove the functionality, run (Will ask for confirmation before taking action):

```r
languageserversetup::languageserver_remove_from_rprofile()
```

If the above does not succeed, remove the `languageserersetup` related code from your `.Rprofile`. Optionally, you can also delete the library where languageserver was installed itself.


## Customizing the behavior

### The location of the languageserver library

The default location for the library is `path.expand(file.path("~", "languageserver-library"))`. The simplest way to customize the location of the library is to use `options(langserver_library = "desired/path/to/library")` and place that option into the `.Rprofile`.

### Used `.Rprofile`

By default, an `.Rprofile` file located in the user's home directory is used. If it does not exist, it is created. If it does exist, code is appended to the end of the file (after user confirmation).


## Development or CRAN version of languageserver?

The `languageserver_install()` function has a `fromGitHub` argument. Set it to `FALSE` to install the CRAN version of the languageserver package. Otherwise, the latest development version is installed from the master branch of the languageserver GitHub repository.


## Options

The default package behavior can be adjusted by the following options, ideally placed in the `.Rprofile` file before the call to `library(languageserversetup)`

* for troubleshooting purposes, use `options(langserver_quiet = FALSE)` to enable diagnostic messages
* use `options(langserver_quiet_serverproc = TRUE)` to disable diagnostic messages for the language server identified process
* to define a custom library location for the languageserver package and its dependencies, use `options(langserver_library = "desired/path/to/library")`


## How does it work, extra options and arguments

Please refer to the help files:

```r
?languageserver_install
?languageserver_startup
?languageserver_add_to_rprofile
?languageserver_remove_from_rprofile
```

## Acknowledgments

- This package would have no point if there was no implementation of the [language server protocol for R](https://github.com/REditorSupport/languageserver)
- Thanks to [rhub](https://github.com/r-hub/rhub) for making cross-platform checking and testing of R packages as easy as it gets
- Thanks to the [Rocker project](https://www.rocker-project.org/) for providing useful Docker images for R work


## License

AGPL-3

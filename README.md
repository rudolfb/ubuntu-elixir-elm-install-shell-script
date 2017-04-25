# ubuntu-elixir-elm-install-shell-script
Shell script that automates install of Elixir, Erlang, Node 7.x, Postgres, pgadmin, Phoenix, Elm, Atom, Sublime Text 3 (dev build).

# Usage

## Warning

**This script is designed for initial installation on a clean system. It is not designed to recognize if software has already been installed or system settings have already been changed.**

In some cases it does not matter if the script is executed on a system with software installed (most of the `apt-get install` ought to be safe), but the Postgres install might overwrite existing files or overwrite the password of the postgres user.

## Installation

- Copy the `install.sh` to the Desktop, for example.

- Assign the file `install.sh` the permission `Allow executing file as program`.

- Open the file with a text editor, search for `GIT_USER_EMAIL`, `GIT_USER_NAME`, `POSTGRES_APP_DB_USER` and `POSTGRES_APP_DB_PASS`, enter the appropriate values and save the changes.

```Shell
POSTGRES_APP_DB_USER=postgres
POSTGRES_APP_DB_PASS=$POSTGRES_APP_DB_USER
GIT_USER_EMAIL="" # Enter your email address here, e.g. a@b.com
GIT_USER_NAME="" # Enter your name here, e.g. Rudolf Bargholz
GIT_CREDENTIAL_HELPER_CACHE_TIMEOUT="86400"
```

- Open a terminal window
```Shell
cd Desktop
./install.sh 2>&1 | tee install.log
```

You will be required to enter your superuser password when the first `sudo` is referenced in the script.

The `... 2>&1 | tee ...` redirects both stdout and stderr to a file and the stdout. You can follow the installation in the terminal, but the terminal output is also saved to the file `install.log` in the same folder as the `install.sh`.

Do _**not**_ start the script as follows:

```Shell
sudo ./install.sh
```

This will start the entire script as a superuser, and any downloaded files will have superuser permissions. The current user will not have permissions for these files and parts of the installation will fail.

The script uses [asdf](https://github.com/asdf-vm/asdf) (https://github.com/asdf-vm/asdf) to install Erlang, Elixir and Elm. The tool `asdf` allows one to install plugins, that then allow the user to install more than one version of the package. One can then use asdf to specify which version should be used. Each plugin may specify prerequisites. The plugins load the application via github, and then build the software. In the case of Erlang this can take a while.

After installing asdf, to install Erlang:

```Shell
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
```

This will return a list of available versions of Erlang:

```Shell
asdf list-all erlang
```

This will install Erlang 19.3:

```Shell
asdf install erlang 19.3
```

This will use Erlang version 19.3:

```Shell
asdf global erlang 19.3
asdf local erlang 19.3
```

# Useful commands

#### List the locally installed packages

```Shell
sudo dpkg -l
```

#### List the locally installed packages and find some packages

```Shell
sudo dpkg -l | grep erlang
```

#### Get top level global npm packages

```Shell
npm -g list --depth=0
```

### When were which packages installed

```Shell
subl /var/log/apt/history.log
```

### Open psql with the user postgres

```Shell
psql -U postgres -W -h localhost
```

You will need to enter the password `postgres`
# Installating OpenSSL locally

This is for my media VPS, where I don't have root access.

I needed a newer version of OpenSSL to compile Python (part of the `pyenv` setup). I wasn't able to use `sudo` or become `root` at any point in the process, so I needed to compile and install a copy of OpenSSL and dump it somewhere in my home dir to use.

I used a couple of resources: the official OpenSSL install docs and the official `pyenv` docs (which pointed to a guide online with more information). See references at the bottom for links.

## Download

You might want to actually go to the OpenSSL website and check what the latest stable version is as there might be a version that's more recent than 1.1.1n (which is what I'm using in the below docs).

```bash
# download the desired version of OpenSSL
cd "$(mktemp -d)"
wget https://www.openssl.org/source/openssl-1.1.1n.tar.gz
wget https://www.openssl.org/source/openssl-1.1.1n.tar.gz.sha256

# ...check the above sha256sum
# you will have to modify the .sha256 sum so that it works with sha256sum
# if it's all good, then extract the downloaded folder and enter it
ex openssl-1.1.1n.tar.gz
cd openssl-1.1.1n
```

## Installation

The installation will involve running some commands first and then adding some stuff to your bash init scripts.

```bash
# create the folder that we will install OpenSSL to
mkdir -p "$HOME/.local/share/openssl"

# install OpenSSL
# using `config` instead of `Configure` because not sure which os/compiler to pick from
./config --prefix="$HOME/.local/share/openssl" --openssldir="$HOME/.local/share/openssl" '-Wl,-rpath,$(LIBRPATH)'
make
make test # optional
make install
```

...and then once you've installed OpenSSL, put the below stuff into your bash init scripts to ensure that you are using the local version instead of the system version:

```bash
prepend_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

prepend_to_path "$HOME/.local/share/openssl/bin"

export LD_LIBRARY_PATH="$HOME/.local/share/openssl/lib"
export LC_ALL="en_US.UTF-8"
export LDFLAGS="-L$HOME/.local/share/openssl/lib -Wl,-rpath,$HOME/.local/share/openssl/lib"
export CPPFLAGS="-I$HOME/.local/share/openssl/include"
```

## Usage

As mentioned at the beginning of this page, I needed a newer version of OpenSSL than what was on my system so that I could compile a version of Python via `pyenv`.

```bash
# not sure if `$HOME` works instead of hardcoding the path
CONFIGURE_OPTS="--with-openssl=/home/user/.local/share/openssl" pyenv install 3.10.4 -v
```

You can use `pyenv install -v` for more output. If the build fails, it will tell you where the log file for the build is, and you can look through that to figure out what went wrong.

## References

1. GitHub openssl/openssl. "[Build and Install](https://github.com/openssl/openssl/blob/master/INSTALL.md)". *[Archived](https://web.archive.org/web/20220602120011/https://github.com/openssl/openssl/blob/master/INSTALL.md)*. Retrieved June 2, 2022.
2. GitHub pyenv/pyenv. "[ERROR: The Python ssl extension was not compiled. Missing the OpenSSL lib?](https://github.com/pyenv/pyenv/wiki/Common-build-problems#error-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib)". *[Archived](https://web.archive.org/web/20220602115913/https://github.com/pyenv/pyenv/wiki/Common-build-problems)*. Retrieved June 2, 2022.
3. Dreamhost Help. "[Installing OpenSSL locally under your username](https://help.dreamhost.com/hc/en-us/articles/360001435926-Installing-OpenSSL-locally-under-your-username)". *[Archived](https://web.archive.org/web/20220602115817/https://help.dreamhost.com/hc/en-us/articles/360001435926-Installing-OpenSSL-locally-under-your-username)*. Retrieved June 2, 2022.
4. unascribed (March 19, 2020). "[Installing Python 3.7 from source with custom openssl installation: test_ssl failed](https://unix.stackexchange.com/questions/573746/installing-python-3-7-from-source-with-custom-openssl-installation-test-ssl-fai)". *[Archived](https://web.archive.org/web/20220602115725/https://unix.stackexchange.com/questions/573746/installing-python-3-7-from-source-with-custom-openssl-installation-test-ssl-fai)*. Retrieved June 2, 2022.

export TARGET=i686-elf
export PREFIX="`pwd`/compiler"
export PATH=$PATH:"`pwd`/compiler"

function unpack_code()
{
    #Go to it
    cd binutils-build
    #Configure the build
    ../binutils-src/binutils-**/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
    #Make everything
    make
    #Make install
    make install
}

echo "Installing libraries for building cross-compiler"
sudo apt install build-essential bison flex libgmp3-dev libmpc-dev texinfo curl

#Check if the binutils archive exists
if [ -f "binutils.tar.gz" ]
then
    echo "Unpacking binutils"
    tar -xvzf "binutils.tar.gz" -C "binutils-src"
else
    echo "Downloading binutils"
    curl https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.gz > binutils.tar.gz
    if [ -d "binutils-src" ]
    then
        echo ""
    else
        mkdir "binutils-src"
    fi
    tar -xvzf "binutils.tar.gz" -C "binutils-src"
fi

if [ -d "binutils-build" ]
then
    echo "Using existing binutils-build directory"
else
    echo "Creating binutils-build"
    mkdir "binutils-build"
fi
#Unpack code
unpack_code
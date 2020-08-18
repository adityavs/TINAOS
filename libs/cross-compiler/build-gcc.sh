export TARGET=i686-elf
export PREFIX=`pwd`/compiler
export PATH=`pwd`/compiler:$PATH

function unpack_code()
{
    #Go to it
    cd gcc-build
    #Configure the build
    ../gcc-src/gcc-**/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers
    #Make everything
    make all-gcc
    #Make the target
    make all-target-libgcc
    #Make the install thingy
    make install-gcc
    #Make the install libgcc target thingy
    make install-target-libgcc
}

echo "Installing libraries for building cross-compiler"
sudo apt install build-essential bison flex libgmp3-dev libmpc-dev texinfo curl

#Check if the binutils archive exists
if [ -f "gcc.tar.gz" ]
then
    echo "Unpacking gcc"
    tar -xvzf "gcc.tar.gz" -C "gcc-src"
else
    echo "Downloading gcc"
    curl https://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.gz > gcc.tar.gz
    if [ -d "gcc-src" ]
    then
        #noop
        echo "No operation running as gcc-src is real"
    else
        mkdir "gcc-src"
    fi
    tar -xvzf "gcc.tar.gz" -C "gcc-src"
fi

if [ -d "gcc-build" ]
then
    echo "Using existing binutils-build directory"
else
    echo "Creating binutils-build"
    mkdir "gcc-build"
fi
#Unpack code
unpack_code
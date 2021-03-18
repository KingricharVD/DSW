#!/bin/bash
echo -e "\033[0;32mHow many CPU cores do you want to be used in compiling process? (Default is 1. Press enter for default.)\033[0m"
read -e CPU_CORES
if [ -z "$CPU_CORES" ]
then
	CPU_CORES=1
fi

# Upgrade the system and install required dependencies
	sudo apt update
	sudo apt install git zip unzip build-essential libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 curl g++-mingw-w64-x86-64 libqt5svg5-dev -y
	echo "1" | sudo update-alternatives --config x86_64-w64-mingw32-g++

# Clone code from official Github repository
	rm -rf DSW
	git clone https://github.com/decenomy/DSW.git

# Entering directory
	cd DSW

# Compile dependencies
	cd depends
	make -j$(echo $CPU_CORES) HOST=x86_64-w64-mingw32 
	cd ..

# Compile
	./autogen.sh
	./configure --prefix=$(pwd)/depends/x86_64-w64-mingw32 --disable-debug --disable-tests --disable-bench --disable-online-rust CFLAGS="-O3" CXXFLAGS="-O3"
	make -j$(echo $CPU_CORES) HOST=x86_64-w64-mingw32
	cd ..

# Create zip file of binaries
	cp DSW/src/__decenomy__d.exe DSW/src/__decenomy__-cli.exe DSW/src/__decenomy__-tx.exe DSW/src/qt/__decenomy__-qt.exe .
	zip __DSW__-Windows.zip __decenomy__d.exe __decenomy__-cli.exe __decenomy__-tx.exe __decenomy__-qt.exe
	rm -f __decenomy__d.exe __decenomy__-cli.exe __decenomy__-tx.exe __decenomy__-qt.exe

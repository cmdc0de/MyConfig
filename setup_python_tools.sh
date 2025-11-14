#!/bin/bash
UNAME=`uname'
INSTALL_DIR="$PWD"
VERBOSE = 0


processCmdLine() {
	while getops "vi:h" opt; do
		case $opt in
			v)
				VERBOSE=1;
				;;
			i)
				INSTALL_DIR="OPTARG"
				;;
			h)
				echo "Usage: $0 [-v] [-i <install dir for python venv]"
				exit 0
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				exit 1;
			;;
		esac
	done
}

install pythonTools() {
	#create venv for python tools
	python3 -m venv ptools
	source ptools/bin/activate
	pip install --upgrade pip
	python3 -m pip install --upgrade pwntools
	#analysis of malware in PDF
	python3 -m pip install --upgrade quicksand
	#extracts text, images, encrypt and decryption, merge pdfs, cropping transforming, hidden data, etc
	python3 -m pip install --upgrade PyPDF2
	#yet another data extractor
	python3 -m pip install --upgrade pdfplumber
	python3 -m pip install archinfo pyvex cle claripy angr
	#https://pdfminersix.readthedocs.io/en/latest/tutorial/install.html
	python3 -m pip install pdfminer.six
}

processCmdLine()
# TODO validate install dir
cd $INSTALL_DIR

if [ $UNAME = "Linux" ]
then
	sudo apt update
	sudo apt install python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential
	pythonTools()
	
elif [ $UNAME="Darwin" ]
then
	if ls $INSTALL_DIR/binutils-* 1> /dev/null 2>&1; then
		#fetch this and review then install
		#wget https://raw.githubusercontent.com/Gallopsled/pwntools-binutils/master/macos/binutils-$ARCH.rb
		#wget https://raw.githubusercontent.com/Gallopsled/pwntools-binutils/master/macos/binutils-aarch64.rb
		brew install ./binutils-$ARCH.rb
		pythonTools()
	else 
		echo "no brew formula downloaded, see note in this script in darwin section"
	fi
else
	echo "UNSUPPORTED OS"
fi


#!/usr/bin/make

default: tmo proposed metric montage

all:  tiff tmo proposed metric montage

CMD="../src/tone_mapping.py"

calc:
	echo "pass"

tiff:
#       dcm2hdr: check pypi for installation
	@echo "Due to patient data protection, only the anonymized tiff files are available."
	@echo "This code is left here only for the sake of completeness."
#	@dcm2hdr.py chest.dcm chest.tiff
#	@dcm2hdr.py head.dcm head.tiff
	@dcm2hdr.py chest.dcm chest.png
	@dcm2hdr.py head.dcm head.png

tmo:
	@bash ./generate_hdr.sh

proposed: head chest

chest:
	@python3 ${CMD} ../base_images/chest.tiff -O . -vvv -c 4 -e 0.7 -x 1 -b 512  --postfix=_proposed -o png
head:
	@python3 ${CMD} ../base_images/head.tiff  -O . -vvv -c 4 -e 0.7 -x 1 -b 512  --postfix=_proposed -o png

montage:
	@bash montage.sh
	@bash montage2.sh
	@bash montage3.sh
	@bash ship_montage.sh

metric:
	@bash evaluate.sh


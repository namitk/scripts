#!/bin/bash

origdir=`pwd`
texmflocal=`kpsexpand '$TEXMFLOCAL'`

cd /tmp
wget 'http://mirrors.ctan.org/fonts/mnsymbol.zip' -O mnsymbol.zip
unzip mnsymbol.zip
cd mnsymbol/tex
latex MnSymbol.ins
sudo mkdir -p $texmflocal/tex/latex/MnSymbol/
sudo mkdir -p $texmflocal/fonts/source/public/MnSymbol/
sudo mkdir -p $texmflocal/doc/latex/MnSymbol/
sudo cp MnSymbol.sty $texmflocal/tex/latex/MnSymbol/MnSymbol.sty
cd ..
sudo cp source/* $texmflocal/fonts/source/public/MnSymbol/
sudo cp MnSymbol.pdf README $texmflocal/doc/latex/MnSymbol/
sudo mkdir -p $texmflocal/fonts/map/dvips/MnSymbol
sudo mkdir -p $texmflocal/fonts/enc/dvips/MnSymbol
sudo mkdir -p $texmflocal/fonts/type1/public/MnSymbol
sudo mkdir -p $texmflocal/fonts/tfm/public/MnSymbol
sudo cp enc/MnSymbol.map $texmflocal/fonts/map/dvips/MnSymbol/
sudo cp enc/*.enc $texmflocal/fonts/enc/dvips/MnSymbol/
sudo cp pfb/*.pfb $texmflocal/fonts/type1/public/MnSymbol/
sudo cp tfm/* $texmflocal/fonts/tfm/public/MnSymbol/
sudo mktexlsr
sudo updmap-sys --enable MixedMap MnSymbol.map

cd /tmp
wget 'http://mirrors.ctan.org/fonts/minionpro/enc-2.000.zip' -O enc-2.000.zip
wget 'http://mirrors.ctan.org/fonts/minionpro/metrics-base.zip' -O metrics-base.zip
wget 'http://mirrors.ctan.org/fonts/minionpro/metrics-full.zip' -O metrics-full.zip
wget 'http://mirrors.ctan.org/fonts/minionpro/scripts.zip' -O scripts.zip
mkdir minionpro-scripts
cd minionpro-scripts
unzip ../scripts.zip
find /opt/Adobe/Reader9/ -iname '*minion*pro*otf' -exec cp -v '{}' otf/ ';'
sudo apt-get install lcdf-typetools
./convert.sh
sudo mkdir -p $texmflocal/fonts/type1/adobe/MinionPro/
sudo cp pfb/*.pfb $texmflocal/fonts/type1/adobe/MinionPro/
cd $texmflocal
sudo unzip /tmp/metrics-base.zip
sudo unzip /tmp/metrics-full.zip
sudo unzip /tmp/enc-2.000.zip  
if [ -e /etc/texmf/updmap.d/10local.cfg ]; then
	sudo touch /etc/texmf/updmap.d/10local.cfg
fi
echo "Map MinionPro.map" | sudo tee -a /etc/texmf/updmap.d/10local.cfg > /dev/null
sudo mktexlsr
sudo update-updmap
sudo updmap-sys

# cleanup
cd /tmp
rm -rf minionpro-scripts scripts.zip metrics-base.zip mnsymbol enc-2.000.zip metrics-full.zip mnsymbol.zip
cd $origdir

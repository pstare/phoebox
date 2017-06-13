#!/bin/bash

cp ~/Library/Pioneer/rekordbox/rekordbox.xml ~/Library/Pioneer/rekordbox/rekordbox.xml.orig
cp ~/Library/Pioneer/rekordbox/rekordbox.xml ./input.xml
./massage.rb
cp ./output.xml ~/Library/Pioneer/rekordbox/rekordbox.xml

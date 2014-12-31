rm -rf bin/
mkdir -p bin/
javac -XDignore.symbol.file=true -d bin src/Hours.java src/HoursCategory.java src/HoursGroup.java src/HoursGroupList.java
jar cf bin/jar_0.jar -C bin hours
rm -rf dist/
mkdir -p dist
ant bundle-hours
cp png/cancel_48.png png/cancel_48@2x.png png/clock_48.png png/clock_48@2x.png png/edit_48.png png/edit_48@2x.png png/gc_24.png png/gc_24@2x.png png/greenc_24.png png/greenc_24@2x.png dist/Hours.app/Contents/Resources/
cp hours.data dist/

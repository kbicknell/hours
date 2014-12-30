rm -rf bin/
mkdir -p bin/
javac -classpath ./lib/rt.jar -d bin src/Hours.java src/HoursCategory.java src/HoursGroup.java src/HoursGroupList.java
jar cf bin/jar_0.jar -C bin hours
rm -rf dist/
mkdir -p dist
ant bundle-hours
cp pdf/cancel.pdf pdf/clock.pdf pdf/clock2.pdf pdf/edit.pdf pdf/gc.pdf pdf/greenc.pdf dist/Hours.app/Contents/Resources/
cp hours.data dist/

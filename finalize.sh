rm -rf bin/
mkdir -p bin/
javac -classpath ./lib/rt.jar -d bin src/Hours.java src/HoursCategory.java src/HoursGroup.java src/HoursGroupList.java
jar cf Hours.app/Contents/Java/jar_0.jar -C bin hours
SetFile -a B Hours.app

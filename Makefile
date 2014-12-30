# non-local paths (may need to change these for your system if you
# want to rebuild icons or get a fresh rt.jar)
inkscape = /Applications/Inkscape.app/Contents/Resources/bin/inkscape
jdkpath = /Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk

# app path shortcuts
conts = Hours.app/Contents
res = $(conts)/Resources
jav = $(conts)/Java

srcfiles = Hours HoursCategory HoursGroup HoursGroupList
src = $(patsubst %,src/%.java,$(srcfiles))
iconnames = cancel clock clock2 edit gc greenc
icons = $(patsubst %,$(res)/%.pdf,$(iconnames))

all : Hours.app bin/jar_0.jar $(icons) dist/Hours.app

.PHONY : all clean Hours.app

dist/Hours.app : bin/jar_0.jar $(icons)
	rm -rf dist/
	mkdir -p dist
	ant bundle-hours
	cp $(icons) dist/Hours.app/Contents/Resources/
	cp hours.data dist/

bin/jar_0.jar : $(src) lib/rt.jar
	rm -rf finalize.sh
	rm -rf bin/
	echo rm -rf bin/ >> finalize.sh
	mkdir -p bin/
	echo mkdir -p bin/ >> finalize.sh
	javac -classpath ./lib/rt.jar -d bin $(src)
	echo javac -classpath ./lib/rt.jar -d bin $(src) >> finalize.sh
	jar cf $@ -C bin hours
	echo jar cf $@ -C bin hours >> finalize.sh
	chmod +x finalize.sh

$(res)/%.pdf : svg/%.svg
	$(inkscape) -z -A $@ $<

lib/rt.jar : $(jdkpath)/Contents/Home/jre/lib/rt.jar
	cp $< $@

clean :
	rm -rf $(jav)/jar_0.jar
	rm -rf $(icons)
	rm -rf lib/rt.jar
	rm -rf finalize.sh
	rm -rf bin/
	rm -rf dist/

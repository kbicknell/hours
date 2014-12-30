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
iconnames = cancel_48 clock_48 edit_48 gc_24 greenc_24
icons = $(patsubst %,png/%.png,$(iconnames))
hidpiicons = $(patsubst %,png/%@2x.png,$(iconnames))

all : dist/Hours.app finalize.sh

.PHONY : all clean

finalize.sh : dist/Hours.app bin/jar_0.jar
	cat compile.sh bundle.sh > finalize.sh
	chmod +x finalize.sh

dist/Hours.app : bin/jar_0.jar $(icons) $(hidpiicons)
	rm -rf bundle.sh
	rm -rf dist/
	echo rm -rf dist/ >> bundle.sh
	mkdir -p dist
	echo mkdir -p dist >> bundle.sh
	ant bundle-hours
	echo ant bundle-hours >> bundle.sh
	cp png/* dist/Hours.app/Contents/Resources/
	echo cp png/* dist/Hours.app/Contents/Resources/ >> bundle.sh
	cp hours.data dist/
	echo cp hours.data dist/ >> bundle.sh

bin/jar_0.jar : $(src) lib/rt.jar
	rm -rf compile.sh
	rm -rf bin/
	echo rm -rf bin/ >> compile.sh
	mkdir -p bin/
	echo mkdir -p bin/ >> compile.sh
	javac -classpath ./lib/rt.jar -d bin $(src)
	echo javac -classpath ./lib/rt.jar -d bin $(src) >> compile.sh
	jar cf $@ -C bin hours
	echo jar cf $@ -C bin hours >> compile.sh

png/%.png : svg/%.svg
	mkdir -p png
	$(inkscape) -z -e $@ $<

png/%_48@2x.png : svg/%_48.svg
	mkdir -p png
	$(inkscape) -z -e $@ --export-width=96 --export-height=96 $<

png/%_24@2x.png : svg/%_24.svg
	mkdir -p png
	$(inkscape) -z -e $@ --export-width=48 --export-height=48 $<

lib/rt.jar : $(jdkpath)/Contents/Home/jre/lib/rt.jar
	cp $< $@

clean :
	rm -rf $(icons)
	rm -rf lib/rt.jar
	rm -rf bundle.sh compile.sh finalize.sh
	rm -rf bin/
	rm -rf dist/
	rm -rf png/

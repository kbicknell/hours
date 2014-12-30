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

dist/Hours.app : bin/jar_0.jar $(icons) $(hidpiicons) Hours.icns
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

Hours.icns : Hours.iconset
	iconutil -c icns -o $@ $^

Hours.iconset : svg/clock2_256.svg
	rm -rf Hours.iconset
	mkdir Hours.iconset
	$(inkscape) -z -e Hours.iconset/icon_16x16.png --export-width=16 --export-height=16 $^
	$(inkscape) -z -e Hours.iconset/icon_16x16@2x.png --export-width=32 --export-height=32 $^
	$(inkscape) -z -e Hours.iconset/icon_32x32.png --export-width=32 --export-height=32 $^
	$(inkscape) -z -e Hours.iconset/icon_32x32@2x.png --export-width=64 --export-height=64 $^
	$(inkscape) -z -e Hours.iconset/icon_128x128.png --export-width=128 --export-height=128 $^
	$(inkscape) -z -e Hours.iconset/icon_128x128@2x.png --export-width=256 --export-height=256 $^
	$(inkscape) -z -e Hours.iconset/icon_256x256.png --export-width=256 --export-height=256 $^
	$(inkscape) -z -e Hours.iconset/icon_256x256@2x.png --export-width=512 --export-height=512 $^
	$(inkscape) -z -e Hours.iconset/icon_512x512.png --export-width=512 --export-height=512 $^
	$(inkscape) -z -e Hours.iconset/icon_512x512@2x.png --export-width=1024 --export-height=1024 $^

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
	rm -rf Hours.iconset
	rm -rf Hours.icns

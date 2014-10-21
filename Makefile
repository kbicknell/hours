# non-local paths (may need to change these for your system)
inkscape = /Applications/Inkscape.app/Contents/Resources/bin/inkscape
jdkpath = /System/Library/Java/JavaVirtualMachines/1.6.0.jdk
appstub = /System/Library/Frameworks/JavaVM.framework/Versions/Current/Resources/MacOS/JavaApplicationStub

# app path shortcuts
conts = Hours.app/Contents
mac = $(conts)/MacOS
res = $(conts)/Resources
jav = $(res)/Java

srcfiles = Hours HoursCategory HoursGroup HoursGroupList
src = $(patsubst %,src/%.java,$(srcfiles))
iconnames = cancel clock clock2 edit gc greenc
icons = $(patsubst %,$(res)/%.pdf,$(iconnames))

all : Hours.app $(jav)/jar_0.jar $(icons) $(jav)/ui.jar $(mac)/JavaApplicationStub

.PHONY : all clean Hours.app

$(jav)/jar_0.jar : $(src)
	rm -rf bin/
	mkdir -p bin/
	javac $(src) -d bin
	jar cf $@ -C bin hours
	rm -rf bin/

$(res)/%.pdf : svg/%.svg
	$(inkscape) -z -A $@ $<

$(jav)/ui.jar : $(jdkpath)/Contents/Classes/ui.jar
	cp $< $@

$(mac)/JavaApplicationStub : $(appstub)
	mkdir -p $(mac)
	cp $< $@

Hours.app :
	SetFile -a B Hours.app

clean :
	rm -rf $(jav)/jar_0.jar
	rm -rf $(icons)
	rm -rf $(jav)/ui.jar
	rm -rf $(mac)

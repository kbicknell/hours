# non-local paths (may need to change these for your system)
inkscape = /Applications/Inkscape.app/Contents/Resources/bin/inkscape
jdkpath = /Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk

# app path shortcuts
conts = Hours.app/Contents
res = $(conts)/Resources
jav = $(res)/Java

srcfiles = Hours HoursCategory HoursGroup HoursGroupList
src = $(patsubst %,src/%.java,$(srcfiles))
iconnames = cancel clock clock2 edit gc greenc
icons = $(patsubst %,$(res)/%.pdf,$(iconnames))

all : Hours.app $(jav)/jar_0.jar $(icons)

.PHONY : all clean Hours.app

$(jav)/jar_0.jar : $(src) $(jav)/rt.jar
	rm -rf bin/
	mkdir -p bin/
	javac -classpath ./$(jav)/rt.jar -d bin $(src)
	jar cf $@ -C bin hours
	rm -rf bin/

$(res)/%.pdf : svg/%.svg
	$(inkscape) -z -A $@ $<

$(jav)/rt.jar : $(jdkpath)/Contents/Home/jre/lib/rt.jar
	cp $< $@

Hours.app :
	SetFile -a B Hours.app

clean :
	rm -rf $(jav)/jar_0.jar
	rm -rf $(icons)
	rm -rf $(jav)/rt.jar

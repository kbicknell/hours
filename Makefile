all : Hours.app

javafiles = Hours.java HoursCategory.java HoursGroup.java HoursGroupList.java
src = $(addprefix src/,$(javafiles))
appstub = /System/Library/Frameworks/JavaVM.framework/Versions/Current/Resources/MacOS/JavaApplicationStub
jgoodiesfiles = jgoodies-common-1.8.0.jar jgoodies-looks-2.6.0.jar
jgoodies = $(addprefix jgoodies/,$(jgoodiesfiles))
icons = resources/cancel.pdf resources/clock.pdf resources/clock2.pdf resources/edit.pdf resources/gc.pdf resources/greenc.pdf

.PHONY : all clean

hours.jar : bin/hours
	jar cf $@ -C bin hours

bin/hours : $(src) bin
	javac $(src) -d bin

bin:
	mkdir -p bin

resources :
	mkdir resources

resources/%.pdf : svg_graphics/%.svg resources
	/Applications/Inkscape.app/Contents/Resources/bin/inkscape -z -A $@ $<

ui.jar :
	cp /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes/ui.jar ui.jar

Hours.app : hours.jar $(appstub) mac/Info.plist $(jgoodies) ui.jar $(icons)
	mkdir -p Hours.app/Contents/MacOS
	mkdir -p Hours.app/Contents/Resources/Java
	cp $(appstub) Hours.app/Contents/MacOS/
	cp mac/Info.plist Hours.app/Contents/
	cp mac/PkgInfo Hours.app/Contents/
	cp mac/Hours.icns Hours.app/Contents/Resources/
	cp hours.jar Hours.app/Contents/Resources/Java/jar_0.jar
	cp resources/*.pdf Hours.app/Contents/Resources/
	$(foreach jgoody,$(jgoodies),cp $(jgoody) Hours.app/Contents/Resources/Java/;)
	cp ui.jar Hours.app/Contents/Resources/Java/
	SetFile -a B Hours.app

clean :
	rm -rf bin/hours
	rm -rf hours.jar
	rm -rf Hours.app
	rm -rf ui.jar
	rm -rf $(icons)
	rm -rf resources

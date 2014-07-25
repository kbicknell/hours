all : Hours.app

javafiles = Hours.java HoursCategory.java HoursGroup.java HoursGroupList.java
src = $(addprefix src/,$(javafiles))
appstub = /System/Library/Frameworks/JavaVM.framework/Versions/Current/Resources/MacOS/JavaApplicationStub
graphicsfiles = cancel.png clock.png clock2.png edit.png gc.png greenc.png process-stop.png
graphics = $(addprefix graphics/,$(graphicsfiles))
jgoodiesfiles = jgoodies-common.jar jgoodies-looks.jar
jgoodies = $(addprefix jgoodies/,$(jgoodiesfiles))

.PHONY : all clean almost-clean

hours.jar : bin/hours $(graphics)
	jar cf $@ graphics -C bin hours

bin/hours : $(src) | bin
	javac $(src) -d bin

bin:
	mkdir -p bin

Hours.app : hours.jar $(appstub) mac/Info.plist jgoodies ui.jar
	mkdir -p Hours.app/Contents/MacOS
	mkdir -p Hours.app/Contents/Resources/Java
	cp $(appstub) Hours.app/Contents/MacOS/
	cp mac/Info.plist Hours.app/Contents/
	cp mac/PkgInfo Hours.app/Contents/
	cp mac/Hours.icns Hours.app/Contents/Resources/
	cp hours.jar Hours.app/Contents/Resources/Java/jar_0.jar
	$(foreach jgoody,$(jgoodies),cp $(jgoody) Hours.app/Contents/Resources/Java/;)
	cp ui.jar Hours.app/Contents/Resources/Java/
	SetFile -a B Hours.app

jgoodies :
	mkdir -p jgoodies
	cd jgoodies && wget http://www.jgoodies.com/download/libraries/common/jgoodies-common-1_8_0.zip
	cd jgoodies && unzip jgoodies-common-1_8_0.zip
	cp jgoodies/jgoodies-common-1.8.0/jgoodies-common-1.8.0.jar jgoodies/jgoodies-common.jar
	rm -rf jgoodies/jgoodies-common-1.8.0/
	cd jgoodies && wget http://www.jgoodies.com/download/libraries/looks/jgoodies-looks-2_6_0.zip
	cd jgoodies && unzip jgoodies-looks-2_6_0.zip
	cp jgoodies/jgoodies-looks-2.6.0/jgoodies-looks-2.6.0.jar jgoodies/jgoodies-looks.jar
	rm -rf jgoodies/jgoodies-looks-2.6.0

almost-clean :
	rm -rf bin/hours
	rm -rf hours.jar
	rm -rf Hours.app

clean : almost-clean
	rm -rf jgoodies

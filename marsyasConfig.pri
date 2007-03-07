######################################################################
# qmake internal options
######################################################################

CONFIG	+= warn_on
CONFIG	+= thread	 # multithreaded
CONFIG -= qt         # by default do not include any Qt stuff

######################################################################
# Build marsyas lib
######################################################################

CONFIG += marsyasLib

#DEFINES+= MARSYAS_VERSION=0.2.10 #is this the way to set a MACRO?!???????

######################################################################
# Build marsyas apps
######################################################################

CONFIG += marsyasConsoleApps
CONFIG += marsyasQt4Apps

######################################################################
# release/debug mode
######################################################################

CONFIG	+= debug_and_release # by default this only builds the release version!

######################################################################
# enable/disable ASSERTIONS/WARNINGS/DIAGNOSTICS/LOGS, etc
######################################################################

#DEFINES += MARSYAS_ASSERT      	#turn on assertions
#DEFINES += MARSYAS_PROFILING		#turn on profiling

#DEFINES += MARSYAS_LOGWARNINGS 	#warning messages in log
#DEFINES += MARSYAS_LOGDEBUG     	#debug messages in log
#DEFINES += MARSYAS_LOGDIAGNOSTIC 	#diagnostic messages in log
#DEFINES += MARSYAS_LOGFILE				#log to file
#DEFINES += MARSYAS_LOGSTDOUT			#log to stdout
#DEFINES += MARSYAS_LOGGUI				#log to GUI

######################################################################
# Audio and MIDI I/O support in marsyas lib
######################################################################

CONFIG += marsyasAUDIOIO
CONFIG += marsyasMIDIIO

# ------------------------------------
# choose which Audio APIs to use:
# ------------------------------------
win32:CONFIG += marsyasAUDIOIO_DS
#win32:CONFIG += marsyasAUDIOIO_ASIO
unix:CONFIG += marsyasAUDIOIO_ALSA
#unix:CONFIG += marsyasAUDIOIO_JACK
#unix:CONFIG += marsyasAUDIOIO_OSS

### no choice about audio API for MacOSX.

######################################################################
# GUI suport for Marsyas library 
######################################################################

#CONFIG += marsyasGUI

######################################################################
# Adds support for MATLAB engine classes
######################################################################

#CONFIG	+= marsyasMATLAB

######################################################################
# Adds support for MP3 MAD
######################################################################

# CONFIG	+= marsyasMAD

######################################################################
# Adds support for oggvorbis
######################################################################

#CONFIG	+= marsyasOGG


#*********************************************************************
# let qmake set stuff based on above user definitions
# DO NOT CHANGE THE LINES BELLOW!
#*********************************************************************

CONFIG(debug, debug|release) {
	DEFINES += MARSYAS_DEBUG
}

CONFIG(release, debug|release) {
	DEFINES += MARSYAS_RELEASE
}

win32 {
	win32-msvc2005:QMAKE_CXXFLAGS_DEBUG += /ZI /Od
	win32-msvc2005:QMAKE_LFLAGS_DEBUG += /INCREMENTAL
}

marsyasGUI:CONFIG += qt
marsyasGUI:DEFINES += MARSYAS_QT
marsyasMATLAB:DEFINES += MARSYAS_MATLAB

INCLUDEPATH 				+= "$$BASEDIR/marsyas" 
marsyasMATLAB:INCLUDEPATH 	+= "$$BASEDIR/marsyas/MATLAB" 
marsyasGUI:INCLUDEPATH 		+= "$$BASEDIR/marsyas/Qt" 

unix {
!macx {    # qmake detects osx as "unix" in 4.2.2.  :/
	DEFINES += MARSYAS_LINUX
	LIBS += -lm
			
	marsyasAUDIOIO {
		DEFINES += MARSYAS_AUDIOIO
		marsyasAUDIOIO_ALSA {
			DEFINES += \
				MARSYAS_ALSA \
				__LINUX_ALSA__
			LIBS += -lasound -lpthread
		}
		marsyasAUDIOIO_JACK {
			DEFINES += \
				MARSYAS_JACK \
				__LINUX_JACK__
			LIBS += -ljack -lpthread
		}
		marsyasAUDIOIO_OSS {
			DEFINES += \
				MARSYAS_OSS \
				__LINUX_OSS__
			LIBS += -lpthread
		}
	}
	
	marsyasMIDIIO {
		DEFINES += \
			MARSYAS_MIDIIO \
			MARSYAS_ALSASEQ \
			__LINUX_ALSASEQ__
		LIBS += -lasound -lpthread
	}
	
	marsyasMATLAB {
		message(Building with MATLAB engine support.)
		#INCLUDEPATH += ???
		#LIBS += ???
		DEFINES 	+= MARSYAS_MATLAB
	}
	
	marsyasMAD {
		LIBS += -lmad
		DEFINES += MARSYAS_MAD
	}
}
}

macx {
	DEFINES += MARSYAS_MACOSX
	LIBS += -framework CoreFoundation
	
	marsyasAUDIOIO {
		DEFINES += \
			MARSYAS_AUDIOIO \
			MARSYAS_COREAUDIO \
			__MACOSX_CORE__
		LIBS += -framework CoreAudio -lpthread
	}
	
	marsyasMIDIIO {
		DEFINES += \
			MARSYAS_MIDIIO \
			MARSYAS_COREMIDI \
			__MACOSX_CORE__
		LIBS += -framework CoreMidi -framework CoreAudio
	}
		
	marsyasMATLAB {
		message(Building with MATLAB engine support.)
		#INCLUDEPATH += ???
		#LIBS += ???
		DEFINES 	+= MARSYAS_MATLAB
	}
}

win32 {
	DEFINES += 	MARSYAS_WIN32 \
		WIN32 \
		_WINDOWS 	
	LIBS 	+= 	-luser32

	CONFIG(release, debug|release){
		DEFINES += NDEBUG
	}
	CONFIG(debug, debug|release){
		DEFINES += _DEBUG
	}
	
	marsyasAUDIOIO {
		DEFINES += MARSYAS_AUDIOIO
		marsyasAUDIOIO_DS {
			DEFINES += \
				MARSYAS_DS \
				__WINDOWS_DS__
			LIBS += -ldsound -L\"$$(DXSDK_DIR)Lib\x86\" #DXSDK_DIR must be defined as an environment variable in windows!
			INCLUDEPATH += "$$(DXSDK_DIR)Include\" #include path for dsound.h
		}
		marsyasAUDIOIO_ASIO {
			DEFINES += \
				MARSYAS_ASIO \
				__WINDOWS_ASIO_
			DEFINES -= UNICODE
			SOURCES += 
				"$$BASEDIR/otherlibs/asio/asio.cpp" \
				"$$BASEDIR/otherlibs/asio/asiodrivers.cpp" \
				"$$BASEDIR/otherlibs/asio/asiolist.cpp" \
				"$$BASEDIR/otherlibs/asio/iasiothiscallresolver.cpp"
			HEADERS += \ 
				"$$BASEDIR/otherlibs/asio/asio.h" \
				"$$BASEDIR/otherlibs/asio/asiodrivers.h" \
				"$$BASEDIR/otherlibs/asio/asiodrvr.h" \
				"$$BASEDIR/otherlibs/asio/asiolist.h" \
				"$$BASEDIR/otherlibs/asio/asiosys.h" \
				"$$BASEDIR/otherlibs/asio/ginclude.h" \
				"$$BASEDIR/otherlibs/asio/iasiodrv.h" \
				"$$BASEDIR/otherlibs/asio/iasiothiscallresolver.h"
		}
	}
	
	marsyasMIDIIO {
		DEFINES += \
			MARSYAS_MIDIIO \
			MARSYAS_WINMM \
			__WINDOWS_MM__
		LIBS += -lwinmm		
	}
	
	marsyasMATLAB{
		message(Building with MATLAB engine support.)
		DEFINES += MARSYAS_MATLAB
		INCLUDEPATH += \"$$(MATLAB)\extern\include\"
		LIBS += -llibeng -llibmx -llibut -L\"$$(MATLAB)/bin/win32\"
	}
	
	marsyasMAD {
		INCLUDEPATH += \"$$(LIBMAD)\"
		DEFINES += MARSYAS_MAD
		CONFIG(release, debug|release){
			message(Building with libMAD MP3 support (release).)
			LIBS += -llibmad -L\"$$(LIBMAD)/msvc++/Release\"
		}
		CONFIG(debug, debug|release){
			message(Building with libMAD MP3 support (debug).)
			LIBS += -llibmad -L\"$$(LIBMAD)/msvc++/Debug\"
		}
	}
}




QT += core qml svg quick quickcontrols2 widgets charts serialport concurrent
CONFIG += c++11
CONFIG += link_pkgconfig
QTPLUGIN += qtvirtualkeyboardplugin

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += main.cpp \
    lib/graphtemp.cpp

HEADERS += \
    lib/graphtemp.h

RESOURCES += qml.qrc \
    images.qrc \
    lib.qrc

#SUBDIRS += lib

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD/lib/
QML2_IMPORT_PATH += $$PWD/lib/

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH += $$PWD/lib/


# Add AtCore library !!!
contains(QT_ARCH, "arm"):{
    message("Cross Compil for ARM")
    INCLUDEPATH +=/usr/include/arm-linux-gnueabihf
}

contains(QT_ARCH, "x86_64"):{
    DEFINES += DESKTOP
    INCLUDEPATH +=/usr/local/lib/x86_64-linux-gnu
    message("Cross Compil X64")
}


INCLUDEPATH += /usr/local/include/AtCore
LIBS += -lAtCore



# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/atcore-eglfs
!isEmpty(target.path): INSTALLS += target



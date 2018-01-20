#include <QtWidgets/QApplication>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QtCore/QDir>
#include <AtCore/AtCore>
#include "lib/graphtemp.h"

#define ATCORE_EGLFS

Q_DECL_EXPORT int main(int argc, char *argv[])
{

    qputenv("XDG_CONFIG_HOME", QByteArray("/etc"));
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QApplication app(argc, argv);
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    app.setOrganizationDomain("thing-printer.com");
    app.setOrganizationName("thing-printer");
    app.setApplicationName("atcore-eglfs");

    qmlRegisterType<AtCore>("org.kde.atcore", 1, 0, "AtCore");

    QQuickView view;
    if (qgetenv("QT_QUICK_CORE_PROFILE").toInt()) {
        QSurfaceFormat f = view.format();
        f.setProfile(QSurfaceFormat::CoreProfile);
        f.setVersion(4, 4);
        view.setFormat(f);
    }
    QString extraImportPath(QStringLiteral("%1/../../../%2"));
    view.engine()->addImportPath(extraImportPath.arg(QGuiApplication::applicationDirPath(),QString::fromLatin1("qml")));
    view.engine()->addImportPath(extraImportPath.arg(QGuiApplication::applicationDirPath(),QString::fromLatin1("lib")));
    view.connect(view.engine(), &QQmlEngine::quit, &app, &QCoreApplication::quit);

    GraphTemp  graphTemp(&view);
    view.rootContext()->setContextProperty("graphTemp", &graphTemp);
    view.engine()->addImportPath("qrc:/lib/");
    view.setSource(QUrl("qrc:/qml/main.qml"));

    if (view.status() == QQuickView::Error)
        return -1;

    view.setResizeMode(QQuickView::SizeRootObjectToView);
    #ifdef DESKTOP
        view.show();
    #else
        view.showFullScreen();
    #endif
    return app.exec();

}

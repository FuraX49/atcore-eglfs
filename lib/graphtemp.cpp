/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "graphtemp.h"
#include <QtCharts/QXYSeries>
#include <QtCharts/QAreaSeries>
#include <QtQuick/QQuickView>
#include <QtQuick/QQuickItem>
#include <QtCore/QDebug>
#include <QtCore/QtMath>
#include <QtCore/QDateTime>

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)

GraphTemp::GraphTemp(QQuickView *appViewer, QObject *parent) :
    QObject(parent),
    m_appViewer(appViewer)
{
    qRegisterMetaType<QAbstractSeries*>();
    qRegisterMetaType<QAbstractAxis*>();
    // 15 mn =15*12
    initData( 2, 180);
}

void GraphTemp::addTemp(QAbstractSeries *series,int serieNum,qreal Temp)
{
    // TODO : find index of serie ....
    if (qIsNaN(Temp)) Temp=0;
    if (series) {
        if (serieNum<m_data.count()) {
            QXYSeries *xySeries = static_cast<QXYSeries *>(series);
            QVector<QPointF> vp = m_data.at(serieNum);
            QPointF p;
            int max = vp.size()-1;
            for (int i(0); i <max; i++) {
                p=vp.at(i+1);
                p.setX(i);
                vp.replace(i,p);
            }
            vp.replace(max,QPointF(max,Temp));
            m_data.replace(serieNum,vp);
            xySeries->replace(vp);
        } else {
            qDebug() << "Error index series in GraphTemp.addTemp()";
        }
    }

}

void GraphTemp::initData(int serieCount, int MesCount)
{
    m_data.clear();
    for (int i(0); i < serieCount; i++) {
        QVector<QPointF> points;
        points.reserve(MesCount);
        qreal x(0);
        qreal y(0);
        for (int j(0); j < MesCount; j++) {
            x = j;
            points.append(QPointF(x, y));
        }
        m_data.append(points);
    }

}

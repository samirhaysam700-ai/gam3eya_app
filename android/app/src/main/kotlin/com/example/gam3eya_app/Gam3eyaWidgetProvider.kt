package com.example.gam3eya_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class Gam3eyaWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.gam3eya_widget_layout)
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            views.setTextViewText(
                R.id.widget_title,
                prefs.getString("widget_title", "جمعيتي") ?: "جمعيتي"
            )
            views.setTextViewText(
                R.id.widget_paid,
                "مدفوع: ${prefs.getString("widget_paid", "0")}"
            )
            views.setTextViewText(
                R.id.widget_remaining,
                "متبقي: ${prefs.getString("widget_remaining", "0")}"
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}

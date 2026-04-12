package cn.inaiworld.clipnote

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

/**
 * Optional foreground service for clipboard monitoring when app is in background.
 * Android 10+ restricts background clipboard access, so this uses a foreground service.
 *
 * NOTE: This service is optional and only needed if you want background monitoring.
 * For MVP, clipboard is captured when the app is in the foreground (onResume in MainActivity).
 */
class ClipboardService : Service() {

    companion object {
        const val CHANNEL_ID = "clipnote_clipboard_channel"
        const val NOTIFICATION_ID = 1001
        const val ACTION_START = "cn.inaiworld.clipnote.START_SERVICE"
        const val ACTION_STOP = "cn.inaiworld.clipnote.STOP_SERVICE"
    }

    private var clipboardManager: ClipboardManager? = null
    private var listener: ClipboardManager.OnPrimaryClipChangedListener? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        clipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> {
                stopForeground(STOP_FOREGROUND_REMOVE)
                stopSelf()
                return START_NOT_STICKY
            }
        }

        startForeground(NOTIFICATION_ID, buildNotification())
        startListening()
        return START_STICKY
    }

    private fun startListening() {
        listener?.let { clipboardManager?.removePrimaryClipChangedListener(it) }
        listener = ClipboardManager.OnPrimaryClipChangedListener {
            // In background we can't call Flutter directly.
            // Save to a shared preference or file that Flutter reads on resume.
            saveClipboardContent()
        }
        clipboardManager?.addPrimaryClipChangedListener(listener!!)
    }

    private fun saveClipboardContent() {
        try {
            val clip = clipboardManager?.primaryClip
            val text = clip?.getItemAt(0)?.coerceToText(this)?.toString()
            if (!text.isNullOrBlank()) {
                // Save to SharedPreferences for Flutter to read on next resume
                val prefs = getSharedPreferences("clipboard_pending", Context.MODE_PRIVATE)
                prefs.edit().putString("pending_text", text).apply()
            }
        } catch (e: Exception) {
            // Ignore - background clipboard access may be restricted
        }
    }

    private fun buildNotification(): Notification {
        val openIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val stopIntent = PendingIntent.getService(
            this,
            0,
            Intent(this, ClipboardService::class.java).apply { action = ACTION_STOP },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("ClipNote")
            .setContentText("Monitoring clipboard...")
            .setSmallIcon(android.R.drawable.ic_menu_edit)
            .setContentIntent(openIntent)
            .addAction(android.R.drawable.ic_delete, "Stop", stopIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Clipboard Monitor",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Monitors clipboard for ClipNote"
            setShowBadge(false)
        }
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        listener?.let { clipboardManager?.removePrimaryClipChangedListener(it) }
        super.onDestroy()
    }
}

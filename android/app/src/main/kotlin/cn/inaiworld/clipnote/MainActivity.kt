package cn.inaiworld.clipnote

import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CLIPBOARD_CHANNEL = "cn.inaiworld.clipnote/clipboard"
    private val CLIPBOARD_EVENT_CHANNEL = "cn.inaiworld.clipnote/clipboard_events"

    private var clipboardEventSink: EventChannel.EventSink? = null
    private var clipboardManager: ClipboardManager? = null
    private var clipboardListener: ClipboardManager.OnPrimaryClipChangedListener? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        clipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager

        // MethodChannel - request clipboard content on demand
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CLIPBOARD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getClipboardText" -> {
                        val text = getCurrentClipboardText()
                        result.success(text)
                    }
                    "startMonitoring" -> {
                        startClipboardMonitoring()
                        result.success(null)
                    }
                    "stopMonitoring" -> {
                        stopClipboardMonitoring()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        // EventChannel - push new clipboard content to Flutter
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CLIPBOARD_EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    clipboardEventSink = events
                    startClipboardMonitoring()
                }

                override fun onCancel(arguments: Any?) {
                    stopClipboardMonitoring()
                    clipboardEventSink = null
                }
            })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleShareIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        // When app comes to foreground, send current clipboard content
        val text = getCurrentClipboardText()
        if (text != null && text.trim().isNotEmpty()) {
            clipboardEventSink?.success(text)
        }
        // Also handle share intent if launched via share
        intent?.let { handleShareIntent(it) }
    }

    private fun handleShareIntent(intent: Intent) {
        if (intent.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
            if (!sharedText.isNullOrEmpty()) {
                clipboardEventSink?.success(sharedText)
            }
        }
    }

    private fun getCurrentClipboardText(): String? {
        return try {
            val clip = clipboardManager?.primaryClip
            clip?.getItemAt(0)?.coerceToText(this)?.toString()
        } catch (e: Exception) {
            null
        }
    }

    private fun startClipboardMonitoring() {
        if (clipboardListener != null) return
        clipboardListener = ClipboardManager.OnPrimaryClipChangedListener {
            val text = getCurrentClipboardText()
            if (text != null && text.trim().isNotEmpty()) {
                clipboardEventSink?.success(text)
            }
        }
        clipboardManager?.addPrimaryClipChangedListener(clipboardListener!!)
    }

    private fun stopClipboardMonitoring() {
        clipboardListener?.let {
            clipboardManager?.removePrimaryClipChangedListener(it)
        }
        clipboardListener = null
    }

    override fun onDestroy() {
        stopClipboardMonitoring()
        super.onDestroy()
    }
}

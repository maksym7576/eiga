package com.example.eiga

import android.view.Display
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        requestHighestRefreshRate()
    }

    override fun onResume() {
        super.onResume()
        requestHighestRefreshRate()
    }

    @Suppress("DEPRECATION")
    private fun requestHighestRefreshRate() {
        val refreshRate = windowManager.defaultDisplay.supportedModes
            .maxOfOrNull(Display.Mode::getRefreshRate)
            ?: return

        window.attributes = window.attributes.apply {
            preferredRefreshRate = refreshRate
        }
    }
}

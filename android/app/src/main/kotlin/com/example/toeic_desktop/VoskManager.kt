package com.example.toeic_desktop

import android.content.Context
import org.vosk.Model
import org.vosk.Recognizer
import org.vosk.android.RecognitionListener
import org.vosk.android.SpeechService
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import android.util.Log
import android.os.Handler
import android.os.Looper
import org.json.JSONObject


class VoskManager(private val context: Context) : RecognitionListener {

    private var recognizer: Recognizer? = null
    private var model: Model? = null
    private var speechService: SpeechService? = null
    private var finalText: String? = null
    private val resultBuilder = StringBuilder()
    private val handler = Handler(Looper.getMainLooper())
    private var timeoutRunnable: Runnable? = null

    fun initIfNeeded() {
        Log.d("VoskManager", "initIfNeeded")
        if (model != null) return
        val assetModelPath = "model/vosk-model-small-en-us-0.15"
        val destModelPath = File(context.filesDir, "model")

        if (!destModelPath.exists()) {
            copyAssetFolder(assetModelPath, destModelPath.absolutePath)
        }

        model = Model(destModelPath.absolutePath)
        recognizer = Recognizer(model, 16000.0f)
    }

    fun startListening() {
        Log.d("VoskManager", "startListening")
        initIfNeeded()
        resultBuilder.clear()
        recognizer?.let {
            speechService = SpeechService(it, 16000.0f)
            speechService?.startListening(this)

            // Start timeout countdown
            timeoutRunnable = Runnable {
                stopListening()
            }
            handler.postDelayed(timeoutRunnable!!, 8000L)
        }
    }

    fun stopListening(): String? {
        Log.d("VoskManager", "stopListening")
        handler.removeCallbacks(timeoutRunnable!!)
        speechService?.stop()
        timeoutRunnable = null
        return resultBuilder.toString().ifBlank { null }
    }

    override fun onPartialResult(hypothesis: String?) {
        try {
            val json = JSONObject(hypothesis)
            val partial = json.optString("partial")

            if (!partial.isNullOrBlank()) {
                timeoutRunnable?.let {
                    handler.removeCallbacks(it)
                }

                timeoutRunnable = Runnable {
                    stopListening()
                }

                handler.postDelayed(timeoutRunnable!!, 8000L)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    override fun onFinalResult(hypothesis: String?) {
        Log.d("VoskManager", "onFinalResult: $hypothesis")
        if (!hypothesis.isNullOrBlank()) {
            resultBuilder.append(hypothesis).append(" ")
        }
        finalText = hypothesis
        stopListening()
    }

    override fun onResult(hypothesis: String?) {
        Log.d("VoskManager", "onResult: $hypothesis")
        if (!hypothesis.isNullOrBlank()) {
            resultBuilder.append(hypothesis).append(" ")
        }
    }
    override fun onError(e: java.lang.Exception?) {
        Log.d("VoskManager", "onError: $e")
        stopListening()
        e?.printStackTrace()
    }

    override fun onTimeout() {
        stopListening()
        Log.d("VoskManager", "onTimeout")
    }

    private fun copyAssetFolder(assetFolder: String, destPath: String) {
        val files = context.assets.list(assetFolder) ?: return
        File(destPath).mkdirs()

        for (fileName in files) {
            val assetPath = "$assetFolder/$fileName"
            val outFile = File(destPath, fileName)

            if (context.assets.list(assetPath)?.isNotEmpty() == true) {
                copyAssetFolder(assetPath, outFile.absolutePath)
            } else {
                val inStream: InputStream = context.assets.open(assetPath)
                val outStream = FileOutputStream(outFile)

                val buffer = ByteArray(1024)
                var read: Int
                while (inStream.read(buffer).also { read = it } != -1) {
                    outStream.write(buffer, 0, read)
                }

                inStream.close()
                outStream.flush()
                outStream.close()
            }
        }
    }
}

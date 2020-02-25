package jp.co.integrityworks.flutter_app123

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.pm.PackageManager
import android.content.pm.PackageManager.PERMISSION_GRANTED
import android.hardware.display.DisplayManager
import android.os.Build
import android.os.Bundle
import android.util.DisplayMetrics
import android.view.TextureView
import android.view.View
import androidx.camera.core.*
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import com.ukixa.barcode.BarcodeReader
import com.ukixa.barcode.BarcodeType
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView
import java.io.File
import java.nio.ByteBuffer
import java.util.*
import java.util.concurrent.Executor
import java.util.concurrent.TimeUnit
import kotlin.collections.ArrayList
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min
import androidx.lifecycle.MutableLiveData

/** Helper type alias used for analysis use case callbacks */
typealias LumaListener = (luma: Double) -> Unit

class QRView(private val registrar: PluginRegistry.Registrar, id: Int) :
        PlatformView, MethodChannel.MethodCallHandler {
    interface ResultHandler {
        fun handleResult(rawResult: Result?)
    }

    companion object {
        const val CAMERA_REQUEST_ID = 513469796
        const val TAG = "KXABR"

        const val KEY_EVENT_ACTION = "key_event_action"
        const val KEY_EVENT_EXTRA = "key_event_extra"
        val EXTENSION_WHITELIST = arrayOf("JPG")
        private const val RATIO_4_3_VALUE = 4.0 / 3.0
        private const val RATIO_16_9_VALUE = 16.0 / 9.0
    }


    // バーコードリーダーオブジェクトを取得する。
    private val _reader: BarcodeReader = BarcodeReader.getInstance()
    private var mFormats: List<BarcodeFormat>? = null
    private var mResultHandler: ResultHandler? = null

    //    var barcodeView: BarcodeView? = null
//    var mPreview: CameraSourcePreview? = null
    private val activity = registrar.activity()
    var cameraPermissionContinuation: Runnable? = null
    var requestingPermission = false
    private var isTorchOn: Boolean = false
    val channel: MethodChannel

    private lateinit var viewFinder: TextureView
    private lateinit var outputDirectory: File
//    private lateinit var broaddcastManager: LocalBroadcastManager
    private lateinit var mainExecutor: Executor

    private var displayId = -1
    private var lensFacing = CameraX.LensFacing.BACK
    private var preview: Preview? = null
    private var imageCapture: ImageCapture? = null
    private var imageAnalyzer: ImageAnalysis? = null
    /** Internal reference of the [DisplayManager] */
    private lateinit var displayManager: DisplayManager


    private val progress  = MutableLiveData<Int>()

    /** Volume down button receiver used to trigger shutter */
//    private val volumeDownReceiver = object : BroadcastReceiver() {
//        override fun onReceive(context: Context, intent: Intent) {
//            when (intent.getIntExtra(KEY_EVENT_EXTRA, KeyEvent.KEYCODE_UNKNOWN)) {
//                // When the volume down button is pressed, simulate a shutter button click
//                KeyEvent.KEYCODE_VOLUME_DOWN -> {
////                    val shutter = container
////                            .findViewById<ImageButton>(R.id.camera_capture_button)
////                    shutter.simulateClick()
//                }
//            }
//        }
//    }
    /**
     * We need a display listener for orientation changes that do not trigger a configuration
     * change, for example if we choose to override config change in manifest or for 180-degree
     * orientation changes.
     */
    private val displayListener = object : DisplayManager.DisplayListener {
        override fun onDisplayAdded(displayId: Int) = Unit
        override fun onDisplayRemoved(displayId: Int) = Unit
        override fun onDisplayChanged(displayId: Int) = view.let { view ->
            Log.d(TAG, "deb::displayId : $displayId, " + this@QRView.displayId)
            if (displayId == this@QRView.displayId) {
                preview!!.setTargetRotation(view.display.rotation)
                imageCapture!!.setTargetRotation(view.display.rotation)
                imageAnalyzer!!.setTargetRotation(view.display.rotation)
            }
        }
    }

    // バーコード読み取りライブラリ
    val formats: Collection<BarcodeFormat>
        get() = if (mFormats == null) {
            BarcodeFormat.Companion.ALL_FORMATS
        } else mFormats!!


    init {
        // getVersionメソッドによりライブラリの著作権情報とバージョン番号（文字列による）を取得できる。
        Log.d(TAG, "version string: " + BarcodeReader.getVersion())
        // getVersionメソッドによりライブラリのバージョン番号（数値による）を取得できる。
        Log.d(TAG, "version number: " + Integer.toHexString(BarcodeReader.getVersionNumber()))
        // getLicenseメソッドによりライブラリの使用許諾番号を取得できる。
        Log.d(TAG, "license: " + _reader.license)

        registrar.addRequestPermissionsResultListener(CameraRequestPermissionsListener())
        channel = MethodChannel(registrar.messenger(), "net.touchcapture.qr.flutterqr/qrview_$id")
        channel.setMethodCallHandler(this)
        checkAndRequestPermission(null)
        registrar.activity().application.registerActivityLifecycleCallbacks(object : Application.ActivityLifecycleCallbacks {
            override fun onActivityPaused(p0: Activity?) {
                if (p0 == registrar.activity()) {
                    Log.d(TAG, "debug :onActivityPaused")
//                    barcodeView?.pause()
                }
            }

            override fun onActivityResumed(p0: Activity?) {
                Log.d(TAG, "debug :onActivityResumed")
                if (p0 == registrar.activity()) {
//                    barcodeView?.resume()
                }
            }

            override fun onActivityStarted(p0: Activity?) {
                Log.d(TAG, "debug :onActivityStarted")
            }

            override fun onActivityDestroyed(p0: Activity?) {
                Log.d(TAG, "debug :onActivityDestroyed")
            }

            override fun onActivitySaveInstanceState(p0: Activity?, p1: Bundle?) {
            }

            override fun onActivityStopped(p0: Activity?) {
            }

            override fun onActivityCreated(p0: Activity?, p1: Bundle?) {
                Log.d(TAG, "debug :onActivityCreated")
            }
        })

        newBar()
    }

    fun newBar() {
        viewFinder = TextureView(registrar.activity().applicationContext)
//        broadcastManager = LocalBroadcastManager.getInstance(view.context)

        // Set up the intent filter that will receive events from our main activity
//        val filter = IntentFilter().apply { addAction(KEY_EVENT_ACTION) }
//        broadcastManager.registerReceiver(volumeDownReceiver, filter)

        // Every time the orientation of device changes, recompute layout
        displayManager = viewFinder.context
                .getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        displayManager.registerDisplayListener(displayListener, null)

        // Determine the output directory
//        outputDirectory = MainActivity.getOutputDirectory(requireContext())

        // Wait for the views to be properly laid out
        viewFinder.post {
            // Keep track of the display in which this view is attached
            displayId = viewFinder.display.displayId

            // Build UI controls and bind all camera use cases
            updateCameraUi()
            bindCameraUseCases()

            // In the background, load latest photo taken (if any) for gallery thumbnail
//            lifecycleScope.launch(Dispatchers.IO) {
//                outputDirectory.listFiles { file ->
//                    EXTENSION_WHITELIST.contains(file.extension.toUpperCase())
//                }?.max()?.let { setGalleryThumbnail(it) }
//            }
        }

        mainExecutor = ContextCompat.getMainExecutor(registrar.activity())

        Log.d(TAG, "deb::setupScanner scan start")
        setupScanner()
    }

    fun flipCamera() {
//        barcodeView?.pause()
//        var settings = barcodeView?.cameraSettings
//
//        if (settings?.requestedCameraId == CameraInfo.CAMERA_FACING_FRONT)
//            settings?.requestedCameraId = CameraInfo.CAMERA_FACING_BACK
//        else
//            settings?.requestedCameraId = CameraInfo.CAMERA_FACING_FRONT
//
//        barcodeView?.cameraSettings = settings
//        barcodeView?.resume()
    }

    private fun toggleFlash() {
//        if (hasFlash()) {
//            barcodeView?.setTorch(!isTorchOn)
//            isTorchOn = !isTorchOn
//        }

    }

    private fun pauseCamera() {
//        if (barcodeView!!.isPreviewActive) {
//            barcodeView?.pause()
//        }
    }

    private fun resumeCamera() {
//        if (!barcodeView!!.isPreviewActive) {
//            barcodeView?.resume()
//        }
    }

    private fun hasFlash(): Boolean {
        return registrar.activeContext().packageManager
                .hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
    }

    override fun getView(): View {

        return initNewView()?.apply {
            //            resume()
        }!!
    }

    private fun initNewView(): TextureView? {
        return viewFinder
    }

//    private fun initBarCodeView(): BarcodeView? {
//        if (barcodeView == null) {
//            barcodeView = createBarCodeView()
//        }
//        return barcodeView
//    }
//
//    private fun createBarCodeView(): BarcodeView? {
//        val barcode = BarcodeView(registrar.activity())
//        barcode.decodeContinuous(
//                object : BarcodeCallback {
//                    override fun barcodeResult(result: BarcodeResult) {
//                        channel.invokeMethod("onRecognizeQR", result.text)
//                    }
//
//                    override fun possibleResultPoints(resultPoints: List<ResultPoint>) {}
//                }
//        )
//        return barcode
//    }

    override fun dispose() {
//        barcodeView?.pause()
//        barcodeView = null
//        broadcastManager.unregisterReceiver(volumeDownReceiver)
        displayManager.unregisterDisplayListener(displayListener)
    }

    private inner class CameraRequestPermissionsListener : PluginRegistry.RequestPermissionsResultListener {
        override fun onRequestPermissionsResult(id: Int, permissions: Array<String>, grantResults: IntArray): Boolean {
            if (id == CAMERA_REQUEST_ID && grantResults[0] == PERMISSION_GRANTED) {
                cameraPermissionContinuation?.run()
                return true
            }
            return false
        }
    }

    private fun hasCameraPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
                activity.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkAndRequestPermission" -> {
                checkAndRequestPermission(result)
            }
            "flipCamera" -> {
                flipCamera()
            }
            "toggleFlash" -> {
                toggleFlash()
            }
            "pauseCamera" -> {
                pauseCamera()
            }
            "resumeCamera" -> {
                resumeCamera()
            }
        }
    }

    private fun checkAndRequestPermission(result: MethodChannel.Result?) {
        if (cameraPermissionContinuation != null) {
            result?.error("cameraPermission", "Camera permission request ongoing", null)
        }

        cameraPermissionContinuation = Runnable {
            cameraPermissionContinuation = null
            if (!hasCameraPermission()) {
                result?.error(
                        "cameraPermission", "MediaRecorderCamera permission not granted", null)
                return@Runnable
            }
        }

        requestingPermission = false
        if (hasCameraPermission()) {
            cameraPermissionContinuation?.run()
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                requestingPermission = true
                registrar
                        .activity()
                        .requestPermissions(
                                arrayOf(Manifest.permission.CAMERA),
                                CAMERA_REQUEST_ID)
            }
        }
    }

//    private fun setGalleryThumbnail(file: File) {
//        // Reference of the view that holds the gallery thumbnail
//        val thumbnail = container.findViewById<ImageButton>(R.id.photo_view_button)
//
//        // Run the operations in the view's thread
//        thumbnail.post {
//
//            // Remove thumbnail padding
//            thumbnail.setPadding(resources.getDimension(R.dimen.stroke_small).toInt())
//
//            // Load thumbnail into circular button using Glide
//            Glide.with(thumbnail)
//                    .load(file)
//                    .apply(RequestOptions.circleCropTransform())
//                    .into(thumbnail)
//        }
//    }

    /** Declare and bind preview, capture and analysis use cases */
    private fun bindCameraUseCases() {

        // Get screen metrics used to setup camera for full screen resolution
        val metrics = DisplayMetrics().also { viewFinder.display.getRealMetrics(it) }
        Log.d(TAG, "Screen metrics: ${metrics.widthPixels} x ${metrics.heightPixels}")
        val screenAspectRatio = aspectRatio(metrics.widthPixels, metrics.heightPixels)
        Log.d(TAG, "Preview aspect ratio: $screenAspectRatio")
        // Set up the view finder use case to display camera preview
        val viewFinderConfig = PreviewConfig.Builder().apply {
            setLensFacing(lensFacing)
            // We request aspect ratio but no resolution to let CameraX optimize our use cases
            setTargetAspectRatio(screenAspectRatio)
            // Set initial target rotation, we will have to call this again if rotation changes
            // during the lifecycle of this use case
            setTargetRotation(viewFinder.display.rotation)
        }.build()

        Log.d(TAG, "deb:: AutoFitPreviewBuilder ")
        // Use the auto-fit preview builder to autom1atically handle size and orientation changes
        preview = AutoFitPreviewBuilder.build(viewFinderConfig, viewFinder)
        Log.d(TAG, "deb:: AutoFitPreviewBuilder 2")

        // Set up the capture use case to allow users to take photos
        val imageCaptureConfig = ImageCaptureConfig.Builder().apply {
            setLensFacing(lensFacing)
            setCaptureMode(ImageCapture.CaptureMode.MIN_LATENCY)
            // We request aspect ratio but no resolution to match preview config but letting
            // CameraX optimize for whatever specific resolution best fits requested capture mode
            setTargetAspectRatio(screenAspectRatio)
            // Set initial target rotation, we will have to call this again if rotation changes
            // during the lifecycle of this use case
            setTargetRotation(viewFinder.display.rotation)
        }.build()

        Log.d(TAG, "deb:: ImageCapture 1")
        imageCapture = ImageCapture(imageCaptureConfig)
        Log.d(TAG, "deb:: ImageCapture 2")

        // Setup image analysis pipeline that computes average pixel luminance in real time
        val analyzerConfig = ImageAnalysisConfig.Builder().apply {
            setLensFacing(lensFacing)
            // In our analysis, we care more about the latest image than analyzing *every* image
            setImageReaderMode(ImageAnalysis.ImageReaderMode.ACQUIRE_LATEST_IMAGE)
            // Set initial target rotation, we will have to call this again if rotation changes
            // during the lifecycle of this use case
            setTargetRotation(viewFinder.display.rotation)
        }.build()

        Log.d(TAG, "deb:: ImageAnalysis 1")
        imageAnalyzer = ImageAnalysis(analyzerConfig).apply {
            setAnalyzer(mainExecutor,
                    LuminosityAnalyzer { luma ->
                        // Values returned from our analyzer are passed to the attached listener
                        // We log image analysis results here --
                        // you should do something useful instead!
//                        val fps = (analyzer as LuminosityAnalyzer).framesPerSecond
//                        Log.d(TAG, "Average luminosity: $luma. " +
//                                "Frames per second: ${"%.01f".format(fps)}")

                        val dataBuf = (analyzer as LuminosityAnalyzer).dataBufTest
                        val data = (analyzer as LuminosityAnalyzer).dataTest
                        val width = metrics.widthPixels
                        val height = metrics.heightPixels
//                        if (DisplayUtils.getScreenOrientation(context) == Configuration.ORIENTATION_PORTRAIT) {
//                            val rotationCount = rotationCount
//                            // setRotationメソッドで入力画像に対する回転量を設定する。
//// 端末が縦向きであっても、カメラからのビデオフレームは横向きに送られてくることが多い。
//// rotation指定により、必要に応じてデコード前にライブラリの内部処理でイメージを回転させる。
//                            _reader.rotation = rotationCount
//                        }
                        // イメージデータからバーコードを読み取る。
                        Log.d(TAG, "ImageAnalysis: width= $width, height= $height." + _reader.types)
                        val barcode = _reader.decode(dataBuf, 640, 480)
                        Log.d(TAG, "ImageAnalysis: barcode= $barcode")

                        if (barcode.isNotEmpty()) { // decodeメソッドが正常に完了した場合、空でない文字列が返される。
// 完了していない場合は空文字列となる。
                            val rawResult = Result()
                            rawResult.contents = barcode
                            // getTypeメソッドで読み取ったバーコードの種類が分かる。
                            rawResult.barcodeFormat = BarcodeFormat.Companion.getFormatById(_reader.type)
                        }
                    })
        }

        Log.d(TAG, "deb:: ImageAnalysis 2")
//        lifecycleOwner(Activity)
        // Apply declared configs to CameraX using the same lifecycle owner

        CameraX.bindToLifecycle(this.activity as LifecycleOwner, preview, imageCapture, imageAnalyzer)
        Log.d(TAG, "deb:: bindToLifecycle 2")
    }

    private fun aspectRatio(width: Int, height: Int): AspectRatio {
        val previewRatio = max(width, height).toDouble() / min(width, height)

        if (abs(previewRatio - RATIO_4_3_VALUE) <= abs(previewRatio - RATIO_16_9_VALUE)) {
            return AspectRatio.RATIO_4_3
        }
        return AspectRatio.RATIO_16_9
    }

    @SuppressLint("RestrictedApi")
    private fun updateCameraUi() {
        Log.d(TAG, "deb::updateCameraUi")
        // Remove previous UI if any
//        container.findViewById<ConstraintLayout>(R.id.camera_ui_container)?.let {
//            container.removeView(it)
//        }
//
//        // Inflate a new view containing all UI for controlling the camera
//        val controls = View.inflate(requireContext(), R.layout.camera_ui_container, container)
//
//        // Listener for button used to capture photo
//        controls.findViewById<ImageButton>(R.id.camera_capture_button).setOnClickListener {
//            // Get a stable reference of the modifiable image capture use case
//            imageCapture?.let { imageCapture ->
//
//                // Create output file to hold the image
//                val photoFile = createFile(outputDirectory, FILENAME, PHOTO_EXTENSION)
//
//                // Setup image capture metadata
//                val metadata = ImageCapture.Metadata().apply {
//                    // Mirror image when using the front camera
//                    isReversedHorizontal = lensFacing == CameraX.LensFacing.FRONT
//                }
//
//                // Setup image capture listener which is triggered after photo has been taken
//                imageCapture.takePicture(photoFile, metadata, mainExecutor, imageSavedListener)
//
//                // We can only change the foreground Drawable using API level 23+ API
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//
//                    // Display flash animation to indicate that photo was captured
//                    container.postDelayed({
//                        container.foreground = ColorDrawable(Color.WHITE)
//                        container.postDelayed(
//                                { container.foreground = null }, ANIMATION_FAST_MILLIS)
//                    }, ANIMATION_SLOW_MILLIS)
//                }
//            }
//        }
//
//        // Listener for button used to switch cameras
//        controls.findViewById<ImageButton>(R.id.camera_switch_button).setOnClickListener {
//            lensFacing = if (CameraX.LensFacing.FRONT == lensFacing) {
//                CameraX.LensFacing.BACK
//            } else {
//                CameraX.LensFacing.FRONT
//            }
//            try {
//                // Only bind use cases if we can query a camera with this orientation
//                CameraX.getCameraWithLensFacing(lensFacing)
//
//                // Unbind all use cases and bind them again with the new lens facing configuration
//                CameraX.unbindAll()
//                bindCameraUseCases()
//            } catch (exc: Exception) {
//                // Do nothing
//            }
//        }
//
//        // Listener for button used to view last photo
//        controls.findViewById<ImageButton>(R.id.photo_view_button).setOnClickListener {
//            Navigation.findNavController(requireActivity(), R.id.fragment_container).navigate(
//                    CameraFragmentDirections.actionCameraToGallery(outputDirectory.absolutePath))
//        }


//        try {
//            // Only bind use cases if we can query a camera with this orientation
//            CameraX.getCameraWithLensFacing(lensFacing)
//
//            // Unbind all use cases and bind them again with the new lens facing configuration
//            CameraX.unbindAll()
//            bindCameraUseCases()
//        } catch (exc: Exception) {
//            // Do nothing
//        }
    }


    fun setupScanner() { // バーコードリーダーオブジェクトの内部状態をリセットする。
// ビデオフレームの処理中（コールバックonPreviewFrameメソッド内で）は、resetしないこと。
        _reader.reset()
//        _reader.rotation = 3
        // setTypesメソッドで読み取りたいバーコードの種類を設定する。
// com.ukixa.barcode.BarcodeTypeに宣言された定数をビット単位ORして指定する。
// 例えば、NW-7だけを読み取り対象としたい場合は types = KXA_NW7; とする。
// EAN-8とEAN-13の2種類が対象なら types = BarcodeType.EAN8 | BarcodeType.EAN13; とすればよい。
        var types = BarcodeType.UNKNOWN
        for (format in formats) {
            types = types or format.id
        }
        _reader.types = types
    }

    private class LuminosityAnalyzer(listener: LumaListener? = null) : ImageAnalysis.Analyzer {
        private val frameRateWindow = 8
        private val frameTimestamps = ArrayDeque<Long>(5)
        private val listeners = ArrayList<LumaListener>().apply { listener?.let { add(it) } }
        private var lastAnalyzedTimestamp = 0L
        var framesPerSecond: Double = -1.0
            private set
        var dataBufTest: ByteBuffer? = null
        var dataTest: ByteArray? = null


        /**
         * Used to add listeners that will be called with each luma computed
         */
        fun onFrameAnalyzed(listener: LumaListener) = listeners.add(listener)

        /**
         * Helper extension function used to extract a byte array from an image plane buffer
         */
        private fun ByteBuffer.toByteArray(): ByteArray {
            rewind()    // Rewind the buffer to zero
            val data = ByteArray(remaining())
            get(data)   // Copy the buffer into a byte array
            return data // Return the byte array
        }

        /**
         * Analyzes an image to produce a result.
         *
         * <p>The caller is responsible for ensuring this analysis method can be executed quickly
         * enough to prevent stalls in the image acquisition pipeline. Otherwise, newly available
         * images will not be acquired and analyzed.
         *
         * <p>The image passed to this method becomes invalid after this method returns. The caller
         * should not store external references to this image, as these references will become
         * invalid.
         *
         * @param image image being analyzed VERY IMPORTANT: do not close the image, it will be
         * automatically closed after this method returns
         * @return the image analysis result
         */
        override fun analyze(image: ImageProxy, rotationDegrees: Int) {
            // If there are no listeners attached, we don't need to perform analysis
            if (listeners.isEmpty()) return

            // Keep track of frames analyzed
            val currentTime = System.currentTimeMillis()
            frameTimestamps.push(currentTime)

            // Compute the FPS using a moving average
            while (frameTimestamps.size >= frameRateWindow) frameTimestamps.removeLast()
            val timestampFirst = frameTimestamps.peekFirst() ?: currentTime
            val timestampLast = frameTimestamps.peekLast() ?: currentTime
            framesPerSecond = 1.0 / ((timestampFirst - timestampLast) /
                    frameTimestamps.size.coerceAtLeast(1).toDouble()) * 1000.0

            // Calculate the average luma no more often than every second
            if (frameTimestamps.first - lastAnalyzedTimestamp >= TimeUnit.SECONDS.toMillis(1)) {
                lastAnalyzedTimestamp = frameTimestamps.first

                // Since format in ImageAnalysis is YUV, image.planes[0] contains the luminance
                var width = image.width
                var height = image.height
                Log.d("debugggg", "LuminosityAnalyzer width:${image.width}, height:${image.height}, $rotationDegrees")
                //width = 640
                //height = 480
                //  plane
                val buffer = image.planes[0].buffer
                dataBufTest = buffer
                // Extract image data from callback object
                val data = buffer.toByteArray()
                dataTest = data
                // Convert the data into an array of pixel values ranging 0-255
                val pixels = data.map { it.toInt() and 0xFF }

                // Compute average luminance for the image
                val luma = pixels.average()

                Log.d(TAG, "deb::override fun analyze")
                // Call all listeners with new value
                listeners.forEach { it(luma) }
            }
        }
    }
}

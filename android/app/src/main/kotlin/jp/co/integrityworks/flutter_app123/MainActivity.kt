package jp.co.integrityworks.flutter_app123

import androidx.annotation.NonNull
import com.ukixa.barcode.BarcodeReader
import com.ukixa.barcode.BarcodeType
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    private val _reader: BarcodeReader = BarcodeReader.getInstance()
    private var mFormats: List<BarcodeFormat>? = null
    // バーコード読み取りライブラリ
    val formats: Collection<BarcodeFormat>
        get() = if (mFormats == null) {
            BarcodeFormat.Companion.ALL_FORMATS
        } else mFormats!!

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val shimPluginRegistry = ShimPluginRegistry(flutterEngine)
        FlutterQrPlugin.registerWith(shimPluginRegistry.registrarFor("jp.co.integrityworks.qr_code.FlutterQrPlugin"))

        Log.d(QRView.TAG, "2debbb::configureFlutterEngine: ")
        initBarcodeReader()
        MethodChannel(flutterEngine.dartExecutor, "com.tasogarei.test/camera").setMethodCallHandler { call, result ->
            when (call.method) {
//                "lib_init" -> {
//                    Log.d(QRView.TAG, "debbb::lib_init")
//                    initBarcodeReader()
//                }
                "camera" -> {
                    val bytes = call.argument<ByteArray>("bytes")
                    val height = call.argument<Int>("height")
                    val width = call.argument<Int>("width")
                    val barcode = _reader.decode(bytes!!, width!!, height!!)
                    result.success(barcode)
                }
            }
        }
    }

    private fun initBarcodeReader() {
//        Log.d(QRView.TAG, "debbb::version string: " + BarcodeReader.getVersion())
//        // getVersionメソッドによりライブラリのバージョン番号（数値による）を取得できる。
//        Log.d(QRView.TAG, "debbb::version number: " + Integer.toHexString(BarcodeReader.getVersionNumber()))
//        // getLicenseメソッドによりライブラリの使用許諾番号を取得できる。
//        Log.d(QRView.TAG, "debbb::license: " + _reader.license)
        setupScanner()
    }

    private fun setupScanner() {
        // バーコードリーダーオブジェクトの内部状態をリセットする。
        _reader.reset()

        _reader.rotation = 1
        // setTypesメソッドで読み取りたいバーコードの種類を設定する。
        var types = BarcodeType.UNKNOWN
        for (format in formats) {
            types = types or format.id
        }
        _reader.types = types
        Log.d(QRView.TAG, "debbb::_reader.types= ${_reader.types}")
    }
}

package jp.co.integrityworks.flutter_app123

import com.ukixa.barcode.BarcodeType
import java.util.*

class BarcodeFormat(val id: Int, val name: String) {

    companion object {
        val UNKNOWN = BarcodeFormat(BarcodeType.UNKNOWN, "UNKNOWN")
        val EAN8 = BarcodeFormat(BarcodeType.EAN8, "JAN-8")
        val UPCE = BarcodeFormat(BarcodeType.UPCE, "UPC-E")
        val EAN13 = BarcodeFormat(BarcodeType.EAN13, "JAN-13")
        val I25 = BarcodeFormat(BarcodeType.ITF, "ITF")
        val DATABAR = BarcodeFormat(BarcodeType.GS1DATABAR, "GS1 DataBar")
        val CODABAR = BarcodeFormat(BarcodeType.NW7, "NW-7")
        val CODE39 = BarcodeFormat(BarcodeType.CODE39, "CODE39")
        //    public static final BarcodeFormat QRCODE = new BarcodeFormat(BarcodeType.QRCODE, "QRCODE");
        val CODE128 = BarcodeFormat(BarcodeType.CODE128, "CODE128")
        val ALL_FORMATS: MutableList<BarcodeFormat> = ArrayList()
        fun getFormatById(id: Int): BarcodeFormat {
            for (format in ALL_FORMATS) {
                if (format.id == id) {
                    return format
                }
            }
            return UNKNOWN
        }

        init {
            ALL_FORMATS.add(EAN8)
            ALL_FORMATS.add(UPCE)
            ALL_FORMATS.add(EAN13)
            ALL_FORMATS.add(I25)
            ALL_FORMATS.add(DATABAR)
            ALL_FORMATS.add(CODABAR)
            ALL_FORMATS.add(CODE39)
            //        ALL_FORMATS.add(BarcodeFormat.QRCODE);
            ALL_FORMATS.add(CODE128)
        }
    }

}
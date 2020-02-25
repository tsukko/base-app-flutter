/*
 KXABarcodeReader Library
 Copyright 2012/2013 TAKAHASHI, Ryoji
 mailto:poohtaro@ukixa.com
 http://ukixa.com/
 */

#ifndef KXABarcodeReader_kxa_barcodereader_symbologies_h
#define KXABarcodeReader_kxa_barcodereader_symbologies_h

enum KXABarcodeType {
    KXA_UNKNOWN_BARCODE_TYPE = 0,
    KXA_NW7 = 0x01,
    KXA_ITF = 0x02,
    KXA_CODE39 = 0x04,
    KXA_CODE128 = 0x08,
    KXA_EAN13 = 0x10,
    KXA_EAN8 = 0x20,
    KXA_UPCE = 0x40,
    KXA_GS1DATABAR = 0x80,
    KXA_QRCODE = 0x40000000,
};
typedef enum KXABarcodeType KXABarcodeType;

#endif

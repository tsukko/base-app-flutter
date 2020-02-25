/*
 KXABarcodeReader Library
 Copyright 2012/2019 TAKAHASHI, Ryoji
 mailto:poohtaro@ukixa.com
 http://ukixa.com/
 */

#ifndef KXABarcodeReader_kxa_barcodereader_h
#define KXABarcodeReader_kxa_barcodereader_h

#include "kxa_barcode_symbologies.h"

#ifdef __cplusplus
extern "C" {
#endif    
    struct kxa_barcode_reader_t;
    typedef struct kxa_barcode_reader_t *kxa_barcode_reader;
    
    const char *kxa_barcode_reader_version(unsigned int *version);
    
    kxa_barcode_reader kxa_create_barcode_reader(void);
    void kxa_destroy_barcode_reader(kxa_barcode_reader reader);
    void kxa_reset_barcode_reader(kxa_barcode_reader reader);
    
    int kxa_set_barcode_types(kxa_barcode_reader reader, int types);
    void kxa_set_cooked_mode_threshold(kxa_barcode_reader reader, unsigned char threshold);
    void kxa_set_grayscale_raster(kxa_barcode_reader reader, const unsigned char *raster, unsigned long raster_size);
    unsigned long kxa_barcode_start_point(kxa_barcode_reader reader);
    unsigned long kxa_barcode_end_point(kxa_barcode_reader reader);
    const unsigned char *kxa_barcode_scanner_feedback(kxa_barcode_reader reader);
    int kxa_barcode_type(kxa_barcode_reader reader);
    const char *kxa_barcode_reader_license(kxa_barcode_reader reader);
    
    int kxa_decode_barcode(kxa_barcode_reader reader);
    const char *kxa_barcode_text(kxa_barcode_reader reader, unsigned long *text_length);

    int kxa_composite_linkage(kxa_barcode_reader reader);
    void kxa_set_grayscale_pixmap(kxa_barcode_reader reader, const unsigned char *base, unsigned long width, unsigned long height, unsigned long bytes_per_row);
    int kxa_decode_composite(kxa_barcode_reader reader);
    const char *kxa_composite_text(kxa_barcode_reader reader, unsigned long *text_length);

    void kxa_prepare_composite(kxa_barcode_reader reader);
    int kxa_decode_composite1(kxa_barcode_reader reader, const unsigned char *raster, unsigned long raster_size);
#ifdef __cplusplus
}
#endif

#endif

// 削除予定？
class Camera {
  static const String flashOn = 'FLASH ON';
  static const String flashOff = 'FLASH OFF';
  static const String cameraFront = 'FRONT CAMERA';
  static const String cameraBack = 'BACK CAMERA';

  static bool isFlashOn(String current) {
    return flashOn == current;
  }

  static bool isBackCamera(String current) {
    return cameraBack == current;
  }
}

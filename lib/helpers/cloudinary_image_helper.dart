class CloudinaryImageHelper {
  //============================================================
  // OPTIMIZE CLOUDINARY IMAGE
  //============================================================

  static String optimize(
    String url, {
    int width = 300,
    int height = 300,
  }) {
    if (url.trim().isEmpty) {
      return url;
    }

    // Already transformed
    if (url.contains('/image/upload/f_auto')) {
      return url;
    }

    return url.replaceFirst(
      '/image/upload/',
      '/image/upload/f_auto,q_auto,w_$width,h_$height,c_fill/',
    );
  }
}
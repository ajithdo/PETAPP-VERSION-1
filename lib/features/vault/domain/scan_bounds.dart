/// Finds a document's page in a camera photo (spec 7.9 "camera scan with
/// auto-crop"). Pure Dart over RGBA pixels: the page is the block whose
/// brightness differs from the table or background around the edges.
library;

class NormRect {
  const NormRect(this.left, this.top, this.right, this.bottom);
  final double left;
  final double top;
  final double right;
  final double bottom;
  double get width => right - left;
  double get height => bottom - top;

  static const fallback = NormRect(0.04, 0.04, 0.96, 0.96);

  @override
  String toString() => 'NormRect($left, $top, $right, $bottom)';
}

/// [rgba] is width × height × 4 bytes. Returns the page bounds in 0..1
/// coordinates, or [NormRect.fallback] when no clear page is found.
NormRect findDocumentBounds(List<int> rgba, int width, int height, {int threshold = 35, double rowShare = 0.2}) {
  if (width < 8 || height < 8 || rgba.length < width * height * 4) return NormRect.fallback;
  int lum(int x, int y) {
    final i = (y * width + x) * 4;
    return (rgba[i] * 54 + rgba[i + 1] * 183 + rgba[i + 2] * 19) >> 8;
  }

  // Background brightness from a thin frame around the photo.
  final fx = (width * 0.03).ceil();
  final fy = (height * 0.03).ceil();
  var sum = 0;
  var n = 0;
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      if (x < fx || x >= width - fx || y < fy || y >= height - fy) {
        sum += lum(x, y);
        n++;
      }
    }
  }
  final bg = sum / n;
  final rows = List<int>.filled(height, 0);
  final cols = List<int>.filled(width, 0);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      if ((lum(x, y) - bg).abs() > threshold) {
        rows[y]++;
        cols[x]++;
      }
    }
  }
  int first(List<int> c, int len) {
    for (var i = 0; i < c.length; i++) {
      if (c[i] > len * rowShare) return i;
    }
    return -1;
  }

  int last(List<int> c, int len) {
    for (var i = c.length - 1; i >= 0; i--) {
      if (c[i] > len * rowShare) return i;
    }
    return -1;
  }

  final top = first(rows, width);
  final bottom = last(rows, width);
  final left = first(cols, height);
  final right = last(cols, height);
  if (top < 0 || left < 0 || bottom <= top || right <= left) return NormRect.fallback;
  final r = NormRect(left / width, top / height, (right + 1) / width, (bottom + 1) / height);
  final area = r.width * r.height;
  if (area < 0.12 || area > 0.985) return NormRect.fallback;
  return r;
}

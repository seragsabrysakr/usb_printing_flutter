import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as img;

class ESCPrinterService {
  final Uint8List? receiptImage;
  List<int>? _bytes;
  List<int>? get bytes => _bytes;
  PaperSize? _paperSize;
  CapabilityProfile? _profile;

  ESCPrinterService(this.receiptImage);

  Future<List<int>> getBytes({
    PaperSize paperSize = PaperSize.mm80,
    CapabilityProfile? profile,
    String name = "default",
  }) async {
    List<int> bytes = [];
    _profile = profile ?? (await CapabilityProfile.load(name: name));
    print(_profile!.name);
    _paperSize = paperSize;
    assert(receiptImage != null);
    assert(_paperSize != null);
    assert(_profile != null);
    Generator generator = Generator(_paperSize!, _profile!);
    img.Image? b = img.decodePng(receiptImage!);
    b?.setPixelRgba(0, 0, 255, 255, 255, 0);
    img.Image _resize =
        img.copyResize(b!, width: 600, interpolation: img.Interpolation.linear);
    bytes += generator.image(_resize);
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}

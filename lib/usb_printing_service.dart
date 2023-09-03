import 'package:flutter/services.dart';
import 'package:pos_printer_manager/pos_printer_manager.dart' as UsbManager;
import 'package:pos_printer_manager/pos_printer_manager.dart';
import 'package:usb_prining/esc_printer_services.dart';

class UsbPrinterService {
  UsbPrinterService() {
    init();
  }
  static UsbManager.USBPrinter? usbPrinter;
  static UsbManager.USBPrinterManager? usbPrinterManager;
  static List<UsbManager.USBPrinter> usbPrinters = [];

  static Future<void> init() async {}

  static Future<List<UsbManager.USBPrinter>> scanUsbPrinters() async {
    usbPrinters = [];
    usbPrinters = await UsbManager.USBPrinterManager.discover();
    return usbPrinters;
  }

  static connectUsbManager(UsbManager.USBPrinter usbPrinter) async {
    var paperSize = PaperSize.mm80;
    var profile = await CapabilityProfile.load();
    usbPrinterManager =
        UsbManager.USBPrinterManager(usbPrinter, paperSize, profile);
    if (usbPrinterManager != null) {
      await usbPrinterManager!.connect();
      usbPrinter.connected = true;
    }
  }

  static printReceipt(Uint8List? receiptImage) async {
    var service = ESCPrinterService(receiptImage);
    var data = await service.getBytes();
    if (usbPrinterManager != null) {
      print("isConnected ${usbPrinterManager?.isConnected}");
      usbPrinterManager?.writeBytes(data, isDisconnect: false);
    }
  }
}

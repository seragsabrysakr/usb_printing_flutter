import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pos_printer_manager/pos_printer_manager.dart';
import 'package:usb_prining/usb_printing_service.dart';

class USBPrinterScreen extends StatefulWidget {
  const USBPrinterScreen({super.key});

  @override
  _USBPrinterScreenState createState() => _USBPrinterScreenState();
}

class _USBPrinterScreenState extends State<USBPrinterScreen> {
  bool _isLoading = false;
  List<USBPrinter> _printers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("USB Printer Screen"),
      ),
      body: ListView(
        children: [
          ..._printers
              .map((printer) => ListTile(
                    title: Text("${printer.name}"),
                    subtitle: Text("${printer.address}"),
                    leading: const Icon(Icons.usb),
                    onTap: () => UsbPrinterService.connectUsbManager(printer),
                    onLongPress: () {
                      Uint8List? receiptImage;
                      UsbPrinterService.printReceipt(receiptImage);
                    },
                    selected: printer.connected,
                  ))
              .toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _scan,
        child:
            _isLoading ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
      ),
    );
  }

  _scan() async {
    setState(() {
      _isLoading = true;
      _printers = [];
    });
    var printers = await UsbPrinterService.scanUsbPrinters();
    setState(() {
      _isLoading = false;
      _printers = printers;
    });
  }
}

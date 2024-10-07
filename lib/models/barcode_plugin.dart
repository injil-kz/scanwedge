import 'package:scanwedge/scanwedge.dart';

// DOCS
// https://github.com/ltrudu/ZebraEntepriseServices/blob/e35cf2ef006c7d3fd1296312da8ab91aa7b5bdba/datawedgeprofileintentswrapper/src/main/java/com/zebra/datawedgeprofileintents/SettingsPlugins/PluginScanner.java#L186
@Deprecated('This is for backwards compatibility, use [BarcodeConfig] instead')
class BarcodePlugin {
  final AimType aimType;
  final int timeoutBetweenScans;
  final List<BarcodeLabelType>? enabledBarcodes, disabledBarcodes;

  BarcodePlugin(
      {this.aimType = AimType.trigger, this.timeoutBetweenScans = 0, this.disabledBarcodes, this.enabledBarcodes});
  Map<String, dynamic> get toMap => {
        'PARAM_LIST': {
          'scanner_selection': 'auto',
          'scanner_input_enabled': 'true',
          'inverse_1d_mode': '2',
          'decoder_upca_preamble': '2',
          'aim_type': AimType.values.indexOf(aimType).toString(),
          if (timeoutBetweenScans > 0) 'same_barcode_timeout': timeoutBetweenScans.toString(),
          ..._mapOfDisabledBarcodes,
          ..._mapOfEnabledBarcodes,
        },
        'PLUGIN_NAME': PluginNames.barcode,
        'RESET_CONFIG': 'true'
      };
  Map get _mapOfDisabledBarcodes => disabledBarcodes == null
      ? {}
      : {for (final entry in disabledBarcodes!) 'decoder_${fetchDecoderName(entry)}': 'false'};
  Map get _mapOfEnabledBarcodes => enabledBarcodes == null
      ? {}
      : {for (final entry in enabledBarcodes!) 'decoder_${fetchDecoderName(entry)}': 'true'};
  static String fetchDecoderName(BarcodeLabelType barcodeLabelType) =>
      barcodeLabelType.name.split('.').last.substring(9).toLowerCase();
  @override
  toString() => toMap.toString();
}

@Deprecated('This is for backwards compatibility, use [BarcodeConfig] instead')
class BarcodeConfiguration {
  final List<BarcodeLabelType> barcodes;
  BarcodeConfiguration({required this.barcodes});
  List<Map> get toMap => [
        for (final barcode in barcodes)
          {
            'decoder_${BarcodePlugin.fetchDecoderName(barcode)}': 'true',
          }
      ];
}

import QRCode from 'qrcode';

window.AlbaStockQr = {
  toDataUrl(value) {
    return QRCode.toDataURL(value, {errorCorrectionLevel: 'M', margin: 1, width: 180});
  },
};
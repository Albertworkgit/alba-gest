import QRCode from 'qrcode';

export function toDataUrl(value) {
  return QRCode.toDataURL(value, {errorCorrectionLevel: 'M', margin: 1, width: 180});
}

window.AlbaStockQr = {
  toDataUrl,
};
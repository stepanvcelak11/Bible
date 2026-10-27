{{flutter_js}}
{{flutter_build_config}}

// Vlastní spuštění Flutteru:
//  * bez zastaralého flutter_service_worker.js – offline zajišťuje sw.js
//    (registruje ho index.html),
//  * vždy „plná“ varianta CanvasKit – stejný soubor ve všech prohlížečích,
//    takže ho service worker má jistě v mezipaměti a aplikace běží offline.
_flutter.loader.load({
  config: { canvasKitVariant: 'full' },
});

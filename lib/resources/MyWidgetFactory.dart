import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fwfh_cached_network_image/fwfh_cached_network_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class MyWidgetFactory extends WidgetFactory with CachedNetworkImageFactory {

}
class CustomCacheManager {
  static const key = 'badroobot';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 14),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const GoogleAdApp());
}

class GoogleAdApp extends StatelessWidget {
  const GoogleAdApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var loaded = false;
  late BannerAd myBanner;
  late AdWidget adWidget;

  loadAd() async {
    loaded = false;
    Get.log('loading ad...');
    const adSize = AdSize(width: 300, height: 50);

    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: adSize,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
    adWidget = AdWidget(ad: myBanner);
    await myBanner
        .load()
        .then((_) => setState(() => loaded = true))
        .onError((e, _) {
      Get.log(e.toString());
      Get.log('ad loading failed...');
      setState(() => loaded = false);
    });
  }

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loaded
            ? Container(
                alignment: Alignment.center,
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
                child: adWidget,
              )
            : const Text('loading...'),
      ),
    );
  }
}

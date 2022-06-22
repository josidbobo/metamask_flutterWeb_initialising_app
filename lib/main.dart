import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './metamask.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'MetaMask Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MetaMaskProvider()..init(),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: const Color(0xFF181818),
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Stack(
              children: [
                Center(
                  child: Consumer<MetaMaskProvider>(
                      builder: (context, provider, child) {
                    late final String text;

                    if (provider.isConnected && provider.isOperatingChain) {
                      text = 'Connected';
                    } else if (provider.isConnected &&
                        !provider.isOperatingChain) {
                      text =
                          'Wrong Chain. Please connect to ${MetaMaskProvider.operatingChain}';
                    } else if (provider.isEnabled || provider.isNotConnected) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Connect'),
                          const SizedBox(
                            height: 8,
                          ),
                          OutlinedButton(
                              onPressed: () async => context.read<MetaMaskProvider>().connect(),
                              style: OutlinedButton.styleFrom(primary: Colors.white),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                      'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1')
                                ],
                              )),
                        ],
                      );
                    } else {
                      text = 'Please use a web3 supported browser';
                    }
                    return ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Colors.purpleAccent,
                                Colors.blue,
                                Colors.red
                              ],
                            ).createShader(bounds),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ));
                  }),
                ),
                Positioned.fill(
                    child: IgnorePointer(
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/image?q=tbn:ANd9GcTicLAkhCzpJeu90V-4G00-B0on5aPGsj_wy9ETkR4g-BdAc8U2-TooYoiMcPcmcT48H7Y&usqp=CAU',
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.025),
                  ),
                )),
              ],
            ),
          );
        });
  }
}

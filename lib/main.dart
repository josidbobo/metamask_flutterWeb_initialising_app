import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'metamask_provider.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MetaMaskProvider()),
    ],
    child:const MyApp(),
  ),
    );
  
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
        initialRoute: '/home',
        routes: {'/home': (context) => const MyHomePage(title: 'MetaMask Project')}
        // home: const MyHomePage(title: 'MetaMask Project'),
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
 
  Widget html = Html(
    data:
        """<img alt='Image on Top' src='https://www.bing.com/th?id=OIP.SUlBcO4pg4yIZxkWBjNWmgHaEx&w=311&h=200&c=8&rs=1&qlt=90&o=6&dpr=1.25&pid=3.1&rm=2'/>""",
    onImageError: (exception, stackTrace) {
      print(exception);
    },
  );

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
                          'Wrong Chain ${context.watch<MetaMaskProvider>().currentChain}. Please connect to Rinkeby!';
                    } else if (provider.isEnabled) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Connect'),
                          const SizedBox(
                            height: 8,
                          ),
                          OutlinedButton(
                              onPressed: () =>
                                  context.read<MetaMaskProvider>().connect(),
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.white),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 450,
                                    child: Image.network(
                                      'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                                      fit: BoxFit.contain,
                                    ),
                                  )
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
                  child: html,
                )),
              ],
            ),
          );
        });
  }
}

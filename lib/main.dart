import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BatteryApp(),
    );
  }
}

class BatteryApp extends HookWidget {
  const BatteryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final batteryLevel = useState<String>('不明');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              batteryLevel.value,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                batteryLevel.value = await _getBatteryLevel();
              },
              child: const Text('残りのバッテリーを取得'),
            ),
          ],
        ),
      ),
    );
  }
}

// バッテリー残量を取得し、String で返すメソッド
Future<String> _getBatteryLevel() async {
  // Flutter ←→ 各プラットフォーム間で使う、アプリ内で一意なチャネル名
  const platform = MethodChannel('method.channel.app/battery');
  try {
    final result = await platform.invokeMethod('getBatteryLevel');
    return result.toString();
  } on Exception catch (e) {
    return e.toString();
  }
}

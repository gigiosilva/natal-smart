import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:natal_smart/screens/configurations.dart';
import 'package:natal_smart/screens/novo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:natal_smart/models/item_smart.dart';

class MyHomePage extends StatefulWidget {
  final List<ItemSmart> _itemsSmart = List();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String broker = 'test.mosquitto.org';
  int port = 1883;
  String username = '';
  String passwd = '';
  String clientIdentifier = 'gigio';
  String _value = '0';
  String _pubTopic = 'gigioxtopic';
  String _subTopic = 'gigioxtopic';

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NovoPage()),
            ).then(
              (itemRecebido) => _atualiza(itemRecebido),
            );
          },
        ),
        title: Text('Natal Smart'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfigPage()),
              ).then(
                (res) async {
                  try {
                    await _disconnect();
                    _connect();
                  } catch (e) {
                    print(e);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget._itemsSmart.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._itemsSmart[indice];
          return ItemHome(transferencia);
        },
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       _value == '1'
      //           ? Image.asset('assets/images/light_on.png')
      //           : Image.asset('assets/images/light_off.png'),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Turn ON',
        child:
            _value == '1' ? Icon(Icons.highlight_off) : Icon(Icons.highlight),
      ),
    );
  }

  void _connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      broker = (prefs.getString('hostname') ?? broker);
      port = (prefs.getInt('port') ?? port);
      clientIdentifier = (prefs.getString('clientID') ?? clientIdentifier);
      _pubTopic = (prefs.getString('pubTopic') ?? _pubTopic);
      _subTopic = (prefs.getString('subsTopic') ?? _subTopic);
    });

    client = mqtt.MqttClient(broker, '');
    client.port = port;
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    if (client.connectionStatus.state == mqtt.MqttConnectionState.connected) {
      setState(() {
        print('EXAMPLE::Mosquitto client connected');
        connectionState = client.connectionStatus.state;
      });
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');

      _disconnect();
    }

    subscription = client.updates.listen(_onMessage);

    _subscribeToTopic(_subTopic);
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    setState(() {
      debugPrint('Mensagem Recebida');
      debugPrint(message);
      _value = message;
    });
  }

  Future _disconnect() async {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      connectionState = null;
      client = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  void _sendMessage() {
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();

    debugPrint('Mensagem pra enviar');
    debugPrint(_value);
    if (_value == '1') {
      setState(() {
        _value = '-1';
      });
      builder.addString('-1');
    } else {
      setState(() {
        _value = '1';
      });
      builder.addString('1');
    }

    /// Publish it
    debugPrint('EXAMPLE::Publishing our topic');
    client.publishMessage(_pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }

  void _atualiza(ItemSmart itemRecebido) {
    debugPrint('Veio aqui');
    debugPrint('$itemRecebido');
    if (itemRecebido != null) {
      setState(() {
        widget._itemsSmart.add(itemRecebido);
      });
    }
  }
}

class ItemHome extends StatelessWidget {
  final ItemSmart _item;

  const ItemHome(this._item);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              leading: Image.asset('assets/images/light_off.png'),
              title: Text(_item.nome),
              subtitle: Text(_item.codigo),
            ),
          ),
          FlatButton(
            child: Icon(
              Icons.highlight,
              color: Colors.white,
            ),
            color: Color.fromRGBO(68, 153, 213, 1.0),
            shape: CircleBorder(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

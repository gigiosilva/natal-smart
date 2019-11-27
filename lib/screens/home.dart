import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:natal_smart/components/item_smart.dart';
import 'package:natal_smart/screens/configurations.dart';
import 'package:natal_smart/screens/novo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:natal_smart/models/item_smart.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String broker = 'test.mosquitto.org';
  int port = 1883;
  String username = '';
  String passwd = '';
  String clientIdentifier = 'gigio';

  List<Item> _itemsSmart = List();

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;

  @override
  void initState() {
    _connect();
    super.initState();
  }

  void _saveItem(Item itemSmart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (itemSmart != null) {
      setState(() => _itemsSmart.add(itemSmart));
      _subscribeToTopic(itemSmart.codigo);
      List<String> stringList = _itemsSmart.map((i) => json.encode(i)).toList();
      prefs.setStringList('items', stringList);
    }
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String> savedList = (prefs.getStringList('items') ?? []);
      List list = json.decode(savedList.toString()) as List;
      List<Item> itemsSmart = list.map((i) => Item.fromJson(i)).toList();

      _itemsSmart = itemsSmart;

      _itemsSmart.forEach((item) => {
        _subscribeToTopic(item.codigo)
      });
    });
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
              (itemRecebido) => _saveItem(itemRecebido),
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
        itemCount: _itemsSmart.length,
        itemBuilder: (context, indice) {
          final item = _itemsSmart[indice];
          return ItemSmart(
            item: item,
            index: indice,
            status: item.status,
            deleted: _deleteItem,
            onChange: _sendMessage,
          );
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
    );
  }

  Future _deleteItem(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Item removedItem = _itemsSmart.removeAt(index);

    List<String> stringList = _itemsSmart.map((i) => json.encode(i)).toList();
    prefs.setStringList('items', stringList);
    client.unsubscribe(removedItem.codigo);
  }

  Future _updateItem(message, topicName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _itemsSmart.forEach((item) {
      if(item.codigo == topicName) {
        item.status = message == '1' ? true : false;
      }
    });

    List<String> stringList = _itemsSmart.map((i) => json.encode(i)).toList();
    prefs.setStringList('items', stringList);
  }

  void _connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      broker = (prefs.getString('hostname') ?? broker);
      port = (prefs.getInt('port') ?? port);
      clientIdentifier = (prefs.getString('clientID') ?? clientIdentifier);
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

    _loadData();
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    final mqtt.MqttPublishMessage recMess = event[0].payload as mqtt.MqttPublishMessage;
    final String message = mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    setState(() {
      debugPrint('Topico');
      debugPrint(recMess.payload.variableHeader.topicName);
      debugPrint('Mensagem Recebida');
      debugPrint(message);
      _updateItem(message, recMess.payload.variableHeader.topicName);
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

  void _sendMessage(topic, value) {
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();

    builder.addString(value);

    /// Publish it
    debugPrint('EXAMPLE::Publishing our topic');
    client.publishMessage(topic, mqtt.MqttQos.exactlyOnce, builder.payload, retain: true);
  }
}

class Item {
  String nome;
  String codigo;
  String valueOn;
  String valueOff;
  bool status;

  Item(
    this.nome,
    this.codigo,
    this.valueOn,
    this.valueOff,
    this.status
  );

  Item.fromJson(Map<String, dynamic> json)
      : nome = json['nome'],
        codigo = json['codigo'],
        valueOn = json['valueOn'],
        valueOff = json['valueOff'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'codigo': codigo,
        'valueOn': valueOn,
        'valueOff': valueOff,
        'status': status,
      };

  @override
  String toString() {
    return 'Transferencia{nome: $nome, codigo: $codigo, valueOn: $valueOn, valueOff: $valueOff, status: $status}';
  }
}

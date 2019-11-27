class Item {
  String nome;
  String codigo;
  bool status;

  Item(
    this.nome,
    this.codigo,
    this.status
  );

  Item.fromJson(Map<String, dynamic> json)
      : nome = json['nome'],
        codigo = json['codigo'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'codigo': codigo,
        'status': status,
      };

  @override
  String toString() {
    return 'Transferencia{nome: $nome, codigo: $codigo, status: $status}';
  }
}

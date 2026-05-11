class UsuarioLogado {

  final int id;

  final String nome;

  final String email;

  final String tipo;

  UsuarioLogado({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
  });

  factory UsuarioLogado.fromJson(
    Map<String, dynamic> json,
  ) {

    return UsuarioLogado(

      id: json['id'],

      nome: json['nome'],

      email: json['email'],

      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'nome': nome,

      'email': email,

      'tipo': tipo,
    };
  }
}
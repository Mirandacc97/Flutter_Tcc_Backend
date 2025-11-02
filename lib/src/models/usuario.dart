class Usuario {
  // O 'id' é opcional (nullable) porque ele não existe
  // antes de ser inserido no banco (que o auto-incrementa).
  final int? id;
  final String nome;
  final String senha; // Esta senha já deve estar "hasheada"

  Usuario({
    this.id,
    required this.nome,
    required this.senha,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      // O 'id' pode não estar presente em todas as consultas
      id: (map['id']),
      nome: (map['nome']),
      senha: (map['senha']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'senha': senha,
    };
  }

  // Opcional: Um método 'copyWith' para facilitar atualizações imutáveis
  Usuario copyWith({
    int? id,
    String? nome,
    String? senha,
  }) {
    return Usuario(
      id: (id ?? this.id),
      nome: (nome ?? this.nome),
      senha: (senha ?? this.senha),
    );
  }
}
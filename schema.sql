CREATE DATABASE barbearia
     CHARACTER SET utf8mb4
     COLLATE utf8mb4_unicode_ci;
USE barbearia;

CREATE TABLE cliente (
     id_cliente      INT AUTO_INCREMENT PRIMARY KEY,
     nome            VARCHAR(100) NOT NULL,
     telefone        VARCHAR(20)  NOT NULL,
     data_nascimento DATE         NOT NULL
);

CREATE TABLE barbeiro (
     id_barbeiro   INT AUTO_INCREMENT PRIMARY KEY,
     nome          VARCHAR(100) NOT NULL,
     telefone      VARCHAR(20)  NOT NULL,
     especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE servico (
     id_servico INT AUTO_INCREMENT PRIMARY KEY,
     nome       VARCHAR(100)  NOT NULL,
     preco      DECIMAL(10,2) NOT NULL CHECK (preco >= 0)
);

CREATE TABLE agendamento (
     id_agendamento   INT AUTO_INCREMENT PRIMARY KEY,
     data_agendamento DATE        NOT NULL,
     horario          TIME        NOT NULL,
     status           VARCHAR(20) NOT NULL DEFAULT 'agendado',
     id_cliente       INT NOT NULL,
     id_barbeiro      INT NOT NULL,
     CONSTRAINT chk_status
          CHECK (status IN ('agendado', 'concluido', 'cancelado')),
     CONSTRAINT uq_barbeiro_horario
          UNIQUE (id_barbeiro, data_agendamento, horario),
     CONSTRAINT fk_agend_cliente
          FOREIGN KEY (id_cliente)  REFERENCES cliente(id_cliente),
     CONSTRAINT fk_agend_barbeiro
          FOREIGN KEY (id_barbeiro) REFERENCES barbeiro(id_barbeiro)
);

CREATE TABLE agendamento_servico (
     id_agendamento INT NOT NULL,
     id_servico     INT NOT NULL,
     PRIMARY KEY (id_agendamento, id_servico),
     CONSTRAINT fk_as_agendamento
          FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento),
     CONSTRAINT fk_as_servico
          FOREIGN KEY (id_servico)     REFERENCES servico(id_servico)
);

CREATE TABLE pagamento (
     id_pagamento    INT AUTO_INCREMENT PRIMARY KEY,
     valor_total     DECIMAL(10,2) NOT NULL CHECK (valor_total >= 0),
     forma_pagamento VARCHAR(30)   NOT NULL,
     id_agendamento  INT NOT NULL UNIQUE,
     CONSTRAINT chk_forma_pagamento
          CHECK (forma_pagamento IN ('dinheiro', 'cartao_credito', 'pix')),
     CONSTRAINT fk_pag_agendamento
          FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento)
);
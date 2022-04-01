//
//  HTTPMetod.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

enum HTTPMetod: String {
    case `GET`
    case POST
    case DELETE
    case HEAD
    case CONNECT
    case OPTIONS
    case TRACE
    case PATCH
}

/*
 INSTRUCTIONS:
 
 -> GET: O método GET solicita a representação de um recurso específico. Requisições utilizando o método GET devem retornar apenas dados.
 
 -> HEAD: O método HEAD solicita uma resposta de forma idêntica ao método GET, porém sem conter o corpo da resposta.
 
 -> POST: O método POST é utilizado para submeter uma entidade a um recurso específico, frequentemente causando uma mudança no estado do recurso ou efeitos colaterais no servidor.
 
 -> PUT: O método PUT substitui todas as atuais representações do recurso de destino pela carga de dados da requisição.

 -> DELETE: O método DELETE remove um recurso específico.
 
 -> CONNECT: O método CONNECT estabelece um túnel para o servidor identificado pelo recurso de destino.

 -> OPTIONS: O método OPTIONS é usado para descrever as opções de comunicação com o recurso de destino.
 
 -> TRACE: O método TRACE executa um teste de chamada loop-back junto com o caminho para o recurso de destino.

 -> PATCH: O método PATCH é utilizado para aplicar modificações parciais em um recurso.
 */

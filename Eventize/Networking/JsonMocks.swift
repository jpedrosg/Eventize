//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

final class JsonMocks {
    static let Event_EventDetails: Data? = """
    {
        "description": "Venha se juntar a nós em uma noite de pura música e talento na grande festa da FIAP! Este evento espetacular trará alguns dos cantores mais talentosos do país para o palco, proporcionando uma experiência musical inigualável. Desfrute de performances incríveis, desde o pop mais atual até as clássicas baladas que aquecem o coração."
    }
    """.data(using: .utf8)
    
    static let Events_EventObject_Array: Data? = """
    [
      {
        "event_uuid": "1",
        "content": {
          "image_url": null,
          "title": "Festa do Samba",
          "subtitle": "Avenida Paulista, 123, São Paulo, SP",
          "price": 40.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Música" },
            { "image_url": null, "text": "Samba" }
          ]
        }
      },
      {
        "event_uuid": "2",
        "content": {
          "image_url": null,
          "title": "Show do Caetano",
          "subtitle": "Rua Augusta, 456, São Paulo, SP",
          "price": 80.0,
          "info": "Lote 2",
          "extra_bottom_info": [
            { "image_url": null, "text": "MPB" },
            { "image_url": null, "text": "Caetano" }
          ]
        }
      },
      {
        "event_uuid": "3",
        "content": {
          "image_url": null,
          "title": "Funk Fest",
          "subtitle": "Largo da Batata, São Paulo, SP",
          "price": 35.0,
          "info": "18+",
          "extra_bottom_info": [
            { "image_url": null, "text": "Funk" },
            { "image_url": null, "text": "Baile" },
            { "image_url": null, "text": "Agito" }
          ]
        }
      },
      {
        "event_uuid": "4",
        "content": {
          "image_url": null,
          "title": "Carnaval no Sambódromo",
          "subtitle": "Sambódromo do Anhembi, São Paulo, SP",
          "price": 60.0,
          "info": "Lote 3",
          "extra_bottom_info": [
            { "image_url": null, "text": "Samba" },
            { "image_url": null, "text": "Carnaval" },
            { "image_url": null, "text": "Festa" },
            { "image_url": null, "text": "Alegria" }
          ]
        }
      },
      {
        "event_uuid": "5",
        "content": {
          "image_url": null,
          "title": "Rock in Rio",
          "subtitle": "Parque Olímpico, Rio de Janeiro, RJ",
          "price": 100.0,
          "info": "Lote 4",
          "extra_bottom_info": [
            { "image_url": null, "text": "Rock" },
            { "image_url": null, "text": "Festival" }
          ]
        }
      },
      {
        "event_uuid": "6",
        "content": {
          "image_url": null,
          "title": "Sertanejo Universitário",
          "subtitle": "Espaço das Américas, São Paulo, SP",
          "price": 55.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Sertanejo" },
            { "image_url": null, "text": "Show" }
          ]
        }
      },
      {
        "event_uuid": "7",
        "content": {
          "image_url": null,
          "title": "Festival de Jazz",
          "subtitle": "Parque Ibirapuera, São Paulo, SP",
          "price": 45.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Jazz" }
          ]
        }
      },
      {
        "event_uuid": "8",
        "content": {
          "image_url": null,
          "title": "Show da Anitta",
          "subtitle": "Credicard Hall, São Paulo, SP",
          "price": 70.0,
          "info": "18+",
          "extra_bottom_info": [
            { "image_url": null, "text": "Pop" },
            { "image_url": null, "text": "Anitta" }
          ]
        }
      },
      {
        "event_uuid": "9",
        "content": {
          "image_url": null,
          "title": "Festival de Dança",
          "subtitle": "Teatro Municipal, São Paulo, SP",
          "price": 50.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Dança" }
          ]
        }
      },
      {
        "event_uuid": "10",
        "content": {
          "image_url": null,
          "title": "Carnaval Eletrônico",
          "subtitle": "Avenida Faria Lima, São Paulo, SP",
          "price": 45.0,
          "info": "18+",
          "extra_bottom_info": [
            { "image_url": null, "text": "Eletrônico" },
            { "image_url": null, "text": "Carnaval" },
            { "image_url": null, "text": "Festa" },
            { "image_url": null, "text": "Agito" }
          ]
        }
      },
      {
        "event_uuid": "11",
        "content": {
          "image_url": null,
          "title": "Exposição de Arte",
          "subtitle": "Museu de Arte Contemporânea, São Paulo, SP",
          "price": 25.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Arte" },
            { "image_url": null, "text": "Exposição" }
          ]
        }
      },
      {
        "event_uuid": "12",
        "content": {
          "image_url": null,
          "title": "Festival de Gastronomia",
          "subtitle": "Praça Roosevelt, São Paulo, SP",
          "price": 30.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Gastronomia" },
            { "image_url": null, "text": "Festival" },
            { "image_url": null, "text": "Comida" }
          ]
        }
      },
      {
        "event_uuid": "13",
        "content": {
          "image_url": null,
          "title": "Feira de Livros",
          "subtitle": "Parque da Juventude, São Paulo, SP",
          "price": 10.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Livros" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "14",
        "content": {
          "image_url": null,
          "title": "Exposição de Carros",
          "subtitle": "Autódromo de Interlagos, São Paulo, SP",
          "price": 15.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Carros" },
            { "image_url": null, "text": "Exposição" }
          ]
        }
      },
      {
        "event_uuid": "15",
        "content": {
          "image_url": null,
          "title": "Concerto de Violino",
          "subtitle": "Teatro Municipal, São Paulo, SP",
          "price": 40.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Música" },
            { "image_url": null, "text": "Concerto" }
          ]
        }
      },
      {
        "event_uuid": "16",
        "content": {
          "image_url": null,
          "title": "Feira de Artesanato",
          "subtitle": "Praça da República, São Paulo, SP",
          "price": 5.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Artesanato" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "17",
        "content": {
          "image_url": null,
          "title": "Festival de Poesia",
          "subtitle": "Casa das Rosas, São Paulo, SP",
          "price": 20.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Poesia" },
            { "image_url": null, "text": "Festival" }
          ]
        }
      },
      {
        "event_uuid": "18",
        "content": {
          "image_url": null,
          "title": "Feira de Quadrinhos",
          "subtitle": "Centro de Eventos, São Paulo, SP",
          "price": 15.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Quadrinhos" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "19",
        "content": {
          "image_url": null,
          "title": "Exposição de Fotografia",
          "subtitle": "Galeria de Arte, São Paulo, SP",
          "price": 10.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Fotografia" },
            { "image_url": null, "text": "Exposição" }
          ]
        }
      },
      {
        "event_uuid": "20",
        "content": {
          "image_url": null,
          "title": "Feira de Ciências",
          "subtitle": "Parque Ibirapuera, São Paulo, SP",
          "price": 0.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Ciências" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "21",
        "content": {
          "image_url": null,
          "title": "Concerto de Piano",
          "subtitle": "Sala São Paulo, São Paulo, SP",
          "price": 35.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Música" },
            { "image_url": null, "text": "Concerto" }
          ]
        }
      },
      {
        "event_uuid": "22",
        "content": {
          "image_url": null,
          "title": "Festival de Teatro",
          "subtitle": "Teatro Alfa, São Paulo, SP",
          "price": 30.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Teatro" },
            { "image_url": null, "text": "Festival" }
          ]
        }
      },
      {
        "event_uuid": "23",
        "content": {
          "image_url": null,
          "title": "Feira de Games",
          "subtitle": "Expo Center Norte, São Paulo, SP",
          "price": 25.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Games" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "24",
        "content": {
          "image_url": null,
          "title": "Festival de Cinema",
          "subtitle": "Cine Belas Artes, São Paulo, SP",
          "price": 20.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Cinema" },
            { "image_url": null, "text": "Festival" }
          ]
        }
      },
      {
        "event_uuid": "25",
        "content": {
          "image_url": null,
          "title": "Exposição de Esculturas",
          "subtitle": "Museu de Arte Moderna, São Paulo, SP",
          "price": 10.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Esculturas" },
            { "image_url": null, "text": "Exposição" }
          ]
        }
      },
      {
        "event_uuid": "26",
        "content": {
          "image_url": null,
          "title": "Festival de Dança Contemporânea",
          "subtitle": "Teatro Municipal, São Paulo, SP",
          "price": 30.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Dança" },
            { "image_url": null, "text": "Festival" },
            { "image_url": null, "text": "Agito" }
          ]
        }
      },
      {
        "event_uuid": "27",
        "content": {
          "image_url": null,
          "title": "Feira de Artes Marciais",
          "subtitle": "Ginásio do Ibirapuera, São Paulo, SP",
          "price": 15.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Artes Marciais" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "28",
        "content": {
          "image_url": null,
          "title": "Festival de Hip-Hop",
          "subtitle": "Praça Roosevelt, São Paulo, SP",
          "price": 25.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Hip-Hop" },
            { "image_url": null, "text": "Festival" }
          ]
        }
      },
      {
        "event_uuid": "29",
        "content": {
          "image_url": null,
          "title": "Feira de Ciências",
          "subtitle": "Parque Ibirapuera, São Paulo, SP",
          "price": 0.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Ciências" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "30",
        "content": {
          "image_url": null,
          "title": "Festival de Circo",
          "subtitle": "Circo Spacial, São Paulo, SP",
          "price": 35.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Circo" },
            { "image_url": null, "text": "Festival" }
          ]
        }
      },
      {
        "event_uuid": "31",
        "content": {
          "image_url": null,
          "title": "Exposição de Fotografia",
          "subtitle": "Galeria de Arte, São Paulo, SP",
          "price": 10.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Fotografia" },
            { "image_url": null, "text": "Exposição" },
            { "image_url": null, "text": "Arte" }
          ]
        }
      },
      {
        "event_uuid": "32",
        "content": {
          "image_url": null,
          "title": "Feira de Artesanato",
          "subtitle": "Praça da República, São Paulo, SP",
          "price": 5.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Artesanato" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "33",
        "content": {
          "image_url": null,
          "title": "Festival de Poesia",
          "subtitle": "Casa das Rosas, São Paulo, SP",
          "price": 20.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Poesia" },
            { "image_url": null, "text": "Festival" }
          ]
        }
      },
      {
        "event_uuid": "34",
        "content": {
          "image_url": null,
          "title": "Feira de Quadrinhos",
          "subtitle": "Centro de Eventos, São Paulo, SP",
          "price": 15.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Quadrinhos" },
            { "image_url": null, "text": "Feira" },
            { "image_url": null, "text": "HQs" }
          ]
        }
      },
      {
        "event_uuid": "35",
        "content": {
          "image_url": null,
          "title": "Exposição de Carros",
          "subtitle": "Autódromo de Interlagos, São Paulo, SP",
          "price": 15.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Carros" },
            { "image_url": null, "text": "Exposição" }
          ]
        }
      },
      {
        "event_uuid": "36",
        "content": {
          "image_url": null,
          "title": "Concerto de Violino",
          "subtitle": "Teatro Municipal, São Paulo, SP",
          "price": 40.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Música" },
            { "image_url": null, "text": "Concerto" },
            { "image_url": null, "text": "Orquestra" }
          ]
        }
      },
      {
        "event_uuid": "37",
        "content": {
          "image_url": null,
          "title": "Festival de Hip-Hop",
          "subtitle": "Praça Roosevelt, São Paulo, SP",
          "price": 25.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Hip-Hop" },
            { "image_url": null, "text": "Festival" },
            { "image_url": null, "text": "Dança" },
            { "image_url": null, "text": "Rap" }
          ]
        }
      },
      {
        "event_uuid": "38",
        "content": {
          "image_url": null,
          "title": "Feira de Artes Marciais",
          "subtitle": "Ginásio do Ibirapuera, São Paulo, SP",
          "price": 15.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Artes Marciais" },
            { "image_url": null, "text": "Feira" },
            { "image_url": null, "text": "Lutas" }
          ]
        }
      },
      {
        "event_uuid": "39",
        "content": {
          "image_url": null,
          "title": "Festival de Dança Contemporânea",
          "subtitle": "Teatro Municipal, São Paulo, SP",
          "price": 30.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Dança" },
            { "image_url": null, "text": "Festival" },
            { "image_url": null, "text": "Performance" }
          ]
        }
      },
      {
        "event_uuid": "40",
        "content": {
          "image_url": null,
          "title": "Feira de Games",
          "subtitle": "Expo Center Norte, São Paulo, SP",
          "price": 25.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Games" },
            { "image_url": null, "text": "Feira" },
            { "image_url": null, "text": "Tecnologia" }
          ]
        }
      },
      {
        "event_uuid": "41",
        "content": {
          "image_url": null,
          "title": "Festival de Cinema",
          "subtitle": "Cine Belas Artes, São Paulo, SP",
          "price": 20.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Cinema" },
            { "image_url": null, "text": "Festival" },
            { "image_url": null, "text": "Filmes" }
          ]
        }
      },
      {
        "event_uuid": "42",
        "content": {
          "image_url": null,
          "title": "Exposição de Esculturas",
          "subtitle": "Museu de Arte Moderna, São Paulo, SP",
          "price": 10.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Esculturas" },
            { "image_url": null, "text": "Exposição" },
            { "image_url": null, "text": "Arte" }
          ]
        }
      },
      {
        "event_uuid": "43",
        "content": {
          "image_url": null,
          "title": "Festival de Gastronomia",
          "subtitle": "Praça Roosevelt, São Paulo, SP",
          "price": 30.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Gastronomia" },
            { "image_url": null, "text": "Festival" },
            { "image_url": null, "text": "Comida" }
          ]
        }
      },
      {
        "event_uuid": "44",
        "content": {
          "image_url": null,
          "title": "Feira de Livros",
          "subtitle": "Parque da Juventude, São Paulo, SP",
          "price": 10.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Livros" },
            { "image_url": null, "text": "Feira" }
          ]
        }
      },
      {
        "event_uuid": "45",
        "content": {
          "image_url": null,
          "title": "Exposição de Carros Antigos",
          "subtitle": "Praça Charles Miller, São Paulo, SP",
          "price": 15.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Carros" },
            { "image_url": null, "text": "Exposição" },
            { "image_url": null, "text": "Antigos" }
          ]
        }
      },
      {
        "event_uuid": "46",
        "content": {
          "image_url": null,
          "title": "Concerto de Piano",
          "subtitle": "Sala São Paulo, São Paulo, SP",
          "price": 35.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Música" },
            { "image_url": null, "text": "Concerto" }
          ]
        }
      },
      {
        "event_uuid": "47",
        "content": {
          "image_url": null,
          "title": "Festival de Teatro",
          "subtitle": "Teatro Alfa, São Paulo, SP",
          "price": 30.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Teatro" },
            { "image_url": null, "text": "Festival" },
            { "image_url": null, "text": "Cultura" }
          ]
        }
      },
      {
        "event_uuid": "48",
        "content": {
          "image_url": null,
          "title": "Feira de Artesanato",
          "subtitle": "Praça da República, São Paulo, SP",
          "price": 5.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Artesanato" },
            { "image_url": null, "text": "Feira" },
            { "image_url": null, "text": "Cultura" }
          ]
        }
      },
      {
        "event_uuid": "49",
        "content": {
          "image_url": null,
          "title": "Festival de Poesia",
          "subtitle": "Casa das Rosas, São Paulo, SP",
          "price": 20.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Poesia" },
            { "image_url": null, "text": "Festival" },
            { "image_url": null, "text": "Cultura" }
          ]
        }
      },
      {
        "event_uuid": "50",
        "content": {
          "image_url": null,
          "title": "Feira de Quadrinhos",
          "subtitle": "Centro de Eventos, São Paulo, SP",
          "price": 15.0,
          "info": "Livre",
          "extra_bottom_info": [
            { "image_url": null, "text": "Quadrinhos" },
            { "image_url": null, "text": "Feira" },
            { "image_url": null, "text": "HQs" },
            { "image_url": null, "text": "Cultura" }
          ]
        }
      }
    ]
    """.data(using: .utf8)
    
    static let Tickets_TicketObject_Array: Data? = """
    [
        {
            "date": "2023-08-25T19:30:00Z",
            "is_valid": true,
            "event_uuid": "1",
            "quantity": 4,
            "title": "Jazz de Verão",
            "description": "Viva a magia do jazz em um festival de verão.",
            "image_url": "https://example.com/image1.jpg"
        },
        {
            "date": "2023-08-20T15:00:00Z",
            "is_valid": false,
            "event_uuid": "2",
            "quantity": 1,
            "title": "Arte: Mestres Modernos",
            "description": "Explore o mundo da arte moderna de artistas renomados.",
            "image_url": "https://example.com/image2.jpg"
        },
        {
            "date": "2023-08-18T20:00:00Z",
            "is_valid": true,
            "event_uuid": "3",
            "quantity": 1,
            "title": "Cinema ao Ar Livre",
            "description": "Assista a um filme sob as estrelas com amigos e família.",
            "image_url": "https://example.com/image3.jpg"
        },
        {
            "date": "2023-09-05T14:30:00Z",
            "is_valid": true,
            "event_uuid": "4",
            "quantity": 2,
            "title": "Fotografia: Capturando a Vida",
            "description": "Descubra a arte de capturar a vida por meio da fotografia.",
            "image_url": "https://example.com/image4.jpg"
        },
        {
            "date": "2023-09-10T19:00:00Z",
            "is_valid": true,
            "event_uuid": "5",
            "quantity": 1,
            "title": "Teatro Uma História de Amor",
            "description": "Viva uma jornada emocional por meio do amor e do drama.",
            "image_url": "https://example.com/image5.jpg"
        },
        {
            "date": "2023-09-12T21:30:00Z",
            "is_valid": true,
            "event_uuid": "6",
            "quantity": 1,
            "title": "Mostra Explorando o Mundo",
            "description": "Explore documentários fascinantes de todo o mundo.",
            "image_url": "https://example.com/image6.jpg"
        },
        {
            "date": "2023-09-14T18:30:00Z",
            "is_valid": true,
            "event_uuid": "7",
            "quantity": 1,
            "title": "Show Bandas Lendárias",
            "description": "Fique eletrizado com as lendárias bandas de rock.",
            "image_url": "https://example.com/image7.jpg"
        },
        {
            "date": "2023-09-16T20:15:00Z",
            "is_valid": true,
            "event_uuid": "8",
            "quantity": 1,
            "title": "Performance Expressões Rítmicas",
            "description": "Testemunhe a beleza das expressões rítmicas por meio da dança.",
            "image_url": "https://example.com/image8.jpg"
        },
        {
            "date": "2023-09-18T22:30:00Z",
            "is_valid": false,
            "event_uuid": "9",
            "quantity": 8,
            "title": "Feira Delícias Culinárias",
            "description": "Saboreie delícias culinárias de chefs e artesãos locais.",
            "image_url": "https://example.com/image9.jpg"
        },
        {
            "date": "2023-09-20T17:45:00Z",
            "is_valid": true,
            "event_uuid": "10",
            "quantity": 1,
            "title": "Exposição Arte em 3D",
            "description": "Descubra o mundo da arte em 3D por meio de esculturas deslumbrantes.",
            "image_url": "https://example.com/image10.jpg"
        }
    ]
    """.data(using: .utf8)
}
